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
    @date  = Time.zone.now.to_date
    if request.method == 'POST'
      if params[:day] && params[:date] && 
        !params[:day].empty? && !params[:date].empty?
        
        day    = params[:day].to_date
        hour   = params[:date][:hour].to_i
        minute = params[:date][:minute].to_i
        date   = DateTime.new(day.year, day.month, day.day, hour, minute)
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
    end
    # FB open graph action
    if Rails.env.production?
      current_user.delay(queue: 'open_graph', 
        priority: 10).open_graph('join', table)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
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
    end
  end

end
