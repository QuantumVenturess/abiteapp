class TablesController < ApplicationController
  before_filter :authenticate, except: :permalink

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
      if params[:day] && params[:date]
        day    = params[:day].to_date
        hour   = params[:date][:hour].to_i
        minute = params[:date][:minute].to_i
        date   = DateTime.new(day.year, day.month, day.day, hour, minute)
        @table.update_attribute(:start_date, date)
        flash[:success] = 'Table started'
        redirect_to @table
      end
    end
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
    flash[:success] = 'This table is ready to go' if table.ready
    respond_to do |format|
      format.html {
        if table.ready
          redirect_to table.room
        else
          flash[:success] = 'You are now sitting at this table'
          redirect_to table
        end
      }
      format.js {
        @seat  = seat
        @table = table
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

  def mark_complete_old
    table = Table.find(params[:id])
    lat = params[:lat]
    lon = params[:lon]
    if lat.nil? || lon.nil? || lat.empty? || lon.empty?
      flash[:error] = 'You must enable GPS to mark complete'
      redirect_to table.room
    elsif current_user == table.user && 
       current_user.sitting?(table) && 
       !current_user.already_marked_complete?(table)

      # Create completion mark
      # completion_mark = current_user.completion_marks.new
      # completion_mark.table_id = table.id
      # completion_mark.save
      # table.calculate_completion
      # table.calculate_completion_proximity(lat, lon)
      if table.complete
        flash[:success] = 'Table complete!'
      else
        flash[:success] = 'You must be near to mark complete'
      end
      redirect_to table
    elsif table.complete
      flash[:success] = 'This table already completed'
      redirect_to table
    else
      flash[:error] = 'Table was not marked complete'
      redirect_to explore_path
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to explore_path
  end

  def permalink
    @table = Table.find(params[:id])
    @description = ["Join #{@table.user.first_name}", 
      "and #{view_context.pluralize(@table.max_seats - 1, 'other')}", 
      "at #{@table.place.name}"].join(' ')
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
