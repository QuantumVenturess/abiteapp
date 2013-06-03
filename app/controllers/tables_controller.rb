class TablesController < ApplicationController
  before_filter :authenticate, except: [:permalink, :show]

  def change_date
    @table = Table.find(params[:id])
    @date  = params[:date].to_date if params[:date]
    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.js {

      }
    end
  end

  def date
    @title = @nav_title = 'Start Date'
    @table = Table.find(params[:id])
    if @table.start_date
      @date = local_time(@table.start_date).to_date
    else
      @date = local_time(Time.zone.now).to_date
    end
    if request.method == 'POST'
      if params[:day] && params[:date] && 
        !params[:day].empty? && !params[:date].empty?

        day    = params[:day].to_date
        hour   = params[:date][:hour].to_i
        minute = params[:date][:minute].to_i
        date   = DateTime.new(day.year, day.month, day.day, hour, minute)
        # Adjust time zone offset
        pdt    = ActiveSupport::TimeZone.new('Pacific Time (US & Canada)')
        date   = date - (pdt.now.formatted_offset.to_i).hour
        @table.update_attribute(:start_date, date)
        if Rails.env.production?
          current_user.delay(queue: 'open_graph', 
            priority: 10).open_graph('start', @table)
        end
        flash[:success] = 'Table started'
        redirect_to @table
      else
        flash[:error] = 'Please choose your table\'s start date'
        redirect_to date_table_path(@table)
      end
    end
    redirect_to @table if @table.user != current_user
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def join
    table = Table.find(params[:id])
    if !current_user.sitting?(table) && table.seats.size < table.max_seats
      seat = current_user.seats.new
      seat.table_id = table.id
      seat.save
      # If all seats filled, mark table as ready
      table.check_ready
      # Create notifications for all users who are sitting at table
      if Rails.env.production?
        table.delay(queue: 'table_join_notifications', 
          priority: 10).create_notifications(current_user, seat)
      else
        table.create_notifications(current_user, seat)
      end
      respond_to do |format|
        format.html {
          if table.ready
            flash[:success] = 'This table is ready to go'
          else
            flash[:success] = 'You are now sitting at this table'
          end
          redirect_to table
        }
        format.js {
          @messages = table.messages.order('created_at DESC')
          @seat     = seat
          @table    = table
        }
        format.json {
          render json: seat_to_json(seat)
        }
      end
      # FB open graph action
      if Rails.env.production?
        current_user.delay(queue: 'open_graph', 
          priority: 10).open_graph('join', table)
      end
    else
      respond_to do |format|
        format.html {
          redirect_to table
        }
        format.js {
          render nothing: true
        }
        format.json {
          if current_user.sitting?(table)
            message = 'Current user is already sitting at this table'
          else
            message = "There are no more seats available 
              (#{table.seats.size}/#{table.max_seats})"
          end
          hash = {
            error: message
          }
          render json: hash
        }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def leave
    table = Table.find(params[:id])
    seat  = Seat.find_by_table_id_and_user_id(table.id, current_user.id)
    if seat.user == current_user
      seat_user = seat.user
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
        format.json {
          hash = {
            success: 1
          }
          render json: hash
        }
      end
    else
      respond_to do |format|
        format.html {
          redirect_to table
        }
        format.js {
          render nothing: true
        }
        format.json {
          hash = {
            error: 'Seat does not belong to current user',
            success: 0
          }
          render json: hash
        }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to explore_path
  end

  def mark_complete
    table = Table.find(params[:id])
    lat = params[:lat]
    lon = params[:lon]
    respond_to do |format|
      format.html {
        redirect_to table.room
      }
      format.js {
        table.calculate_completion_proximity(lat, lon, current_user)
        @table = table
        @url   = url_for(table_path(table))
        if table.complete
          @key   = 'success'
          @value = 'Table completed'
        else
          @key   = 'error'
          @value = 'You must be near location to mark complete'
        end
      }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to explore_path
  end

  def message
    table = Table.find(params[:id])
    if current_user.sitting?(table) && 
      params[:content] && !params[:content].empty?

      message = current_user.messages.new
      message.content  = params[:content]
      message.table_id = table.id
      message.save
      # Create notifications
      if Rails.env.production?
        table.delay(queue: 'table_message_notifications',
          priority: 10).create_message_notifications(message)
      else
        table.create_message_notifications(message)
      end
      respond_to do |format|
        format.html {
          flash[:success] = 'Message sent'
          redirect_to table
        }
        format.js {
          @message = message
          @table   = table
        }
        format.json {
          render json: message_to_json(message)
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:notice] = 'You must be seated to message'
          redirect_to table
        }
        format.js {
          render nothing: true
        }
        format.json {
          hash = {
            error: 'Current user is not sitting at table or content is empty'
          }
          render json: hash
        }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def messages
    table = Table.find(params[:id])
    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.json {
        render json: messages_to_json(table.messages.order('created_at DESC'))
      }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def permalink
    @table = Table.find(params[:id])
    @description = table_description(@table)
    @href = "http://abiteapp.com#{table_path(@table)}"
    @type = 'abiteapp:table'
    @url  = "#{@href}/permalink"
    render layout: false
  rescue ActiveRecord::RecordNotFound
    redirect_to explore_path
  end

  def seats
    table = Table.find(params[:id])
    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.json {
        render json: seats_to_json(table.seats)
      }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def show
    @table = Table.find(params[:id])
    @place = @table.place
    @title = @place.name
    # If table's creator is current user and table has no start date
    if @table.user == current_user && @table.start_date.nil?
      flash[:notice] = 'Please choose a start date for your table'
      redirect_to date_table_path(@table)
    end
    # If user is sitting at table, show messages
    if signed_in? && current_user.sitting?(@table)
      @messages = @table.messages.order('created_at DESC')
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to explore_path
  end

  def start
    @title = @nav_title = 'Start'
    @location = params[:location].nil? ?
      current_user.location : params[:location]
    if params[:term]
      consumer = OAuth::Consumer.new(yelp_consumer_key, yelp_consumer_secret, 
        { site: "http://#{yelp_api_host}" })
      access_token = OAuth::AccessToken.new(consumer, yelp_token, 
        yelp_token_secret)
      limit = 10
      if params[:location] && !params[:location].empty?
        location = URI.escape(params[:location])
      elsif current_user.location
        location = URI.escape(current_user.location)
      else
        location = URI.escape(yelp_default_location)
      end
      term = URI.escape(params[:term])
      path = "/v2/search?term=#{term}&limit=#{limit}&"
      if params[:ll]
        path += "ll=#{params[:ll]}"
      else
        path += "location=#{location}"
      end
      json    = access_token.get(path).body
      results = JSON.parse(json)['businesses']
    end
    respond_to do |format|
      format.html {
        @results = results
      }
      format.js {
        @results = results
      }
      format.json {
        render json: results
      }
    end
  end

end
