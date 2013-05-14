class RoomsController < ApplicationController
  before_filter :authenticate

  def message
    room = Room.find(params[:id])
    if current_user.sitting?(room.table)
      message = current_user.messages.new
      message.content = params[:content]
      message.room_id = room.id
      message.save
      # Create notifications for all users in the room
      if Rails.env.production?
        room.delay(queue: 'room_message_notifications', 
          priority: 10).create_notifications(message)
      else
        room.create_notifications(message)
      end
      respond_to do |format|
        format.html {
          flash[:success] = 'Message sent'
          redirect_to room
        }
        format.js {
          @message = message
          @room = room
        }
      end
    else
      flash[:notice] = 'You must be seated to message'
      redirect_to room.table
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to sitting_path
  end

  def show
    @room = Room.find(params[:id])
    @title = @nav_title = 'Message Room'
    redirect_to sitting_path if !current_user.sitting?(@room.table)
    @messages = @room.messages.order('created_at ASC')
  rescue ActiveRecord::RecordNotFound
    redirect_to sitting_path
  end

end
