class RoomsController < ApplicationController
  before_filter :authenticate

  def message
    room = Room.find(params[:id])
    if current_user.sitting?(room.table)
      message = current_user.messages.new
      message.content = params[:content]
      message.room_id = room.id
      message.save
      room.table.seats.each do |seat|
        if seat.user != message.user
          notification = seat.user.notifications.new
          notification.message_id = message.id
          notification.save
        end
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
      redirect_to sitting_path
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
