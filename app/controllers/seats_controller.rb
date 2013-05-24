class SeatsController < ApplicationController
  before_filter :authenticate

  def destroy
    seat = Seat.find(params[:id])
    seat_user = seat.user
    table = seat.table
    seat.destroy
    # If there was more than 1 user at the table
    if table.seats.size > 0
      # If table was ready, delete the notifications about it being ready
      if table.ready
        table.notifications.each do |notification|
          notification.destroy
        end
        # If only 1 person is left, make table not ready
        if table.max_seats - table.seats.size == 1
          table.ready = false
          table.save
        end
      end
      # If the table's creator leaves the table, give ownership to next user
      if table.user == seat_user
        next_seat = table.seats.order('created_at')[0]
        table.user_id = next_seat.user.id
        table.save
      end
    # If there are no more users at the table
    else
      table.destroy
      flash[:notice] = 'You were the last to leave the table'
    end
    respond_to do |format|
      format.html {
        if table.seats.size == 0
          redirect_to explore_path
        else
          flash[:notice] = 'You have left the table'
          redirect_to table
        end
      }
      format.js {
        if table.seats.size == 0
          @destroy = true
        else
          @destroy = false
          @table   = table
        end
      }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to explore_path
  end

  def explore
    @title = @nav_title = 'Explore'
    @tables = current_user.tables_not_sitting.page(params[:p])
    respond_to do |format|
      format.html
      format.js
      format.json {
        dictionary = {
          pages: @tables.num_pages,
          tables: tables_to_json(@tables)
        }
        render json: dictionary
      }
    end
  end

  def sitting
    @title = @nav_title = 'Sitting'
    @seats = current_user.sitting_waiting.page(params[:p])
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
