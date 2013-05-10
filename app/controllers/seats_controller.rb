class SeatsController < ApplicationController
  before_filter :authenticate

  def destroy
    seat = Seat.find(params[:id])
    table = seat.table
    seat.destroy
    if table.seats.size > 0
      if table.ready
        table.notifications.each do |notification|
          notification.destroy
        end
        # If only 1 person is left
        if table.max_seats - table.seats.size == 1
          table.ready = false
          table.save
        end
      end
    end
    respond_to do |format|
      format.html {
        if table.seats.size > 0
          flash[:notice] = 'You have left the table'
          redirect_to table
        else
          table.destroy
          flash[:notice] = 'You were the last to leave the table'
          redirect_to explore_path
        end
      }
      format.js {
        @table = table
      }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to explore_path
  end

  def explore
    @title = @nav_title = 'Explore'
    @tables = Table.where('complete = ? AND ready = ?', 
      false, false).order('created_at DESC').page(params[:p])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def sitting
    @title = @nav_title = 'Sitting'
    @ready   = current_user.sitting_ready
    @waiting = current_user.sitting_waiting
    @seats_ready   = @ready.page(params[:p])
    @seats_waiting = @waiting.page(params[:p])
    cookie = cookies[:sitting]
    if !cookie || cookie == '' || cookie == 'ready'
      @ready_switch   = 'active'
      @waiting_switch = ''
    else
      @ready_switch   = ''
      @waiting_switch = 'active'
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def sitting_switch
    cookie = cookies[:sitting]
    if !cookie || cookie == '' || cookie == 'ready'
      cookies[:sitting] = 'waiting'
    else
      cookies[:sitting] = 'ready'
    end
    respond_to do |format|
      format.html {
        redirect_to sitting_path
      }
      format.js
    end
  end

end
