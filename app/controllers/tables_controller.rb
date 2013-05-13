class TablesController < ApplicationController
  before_filter :authenticate, except: :permalink

  def join
    table = Table.find(params[:id])
    seat = current_user.seats.new
    seat.table_id = table.id
    seat.save
    # If all seats filled, mark table as ready
    table.check_ready
    # Create notifications for all users who are sitting at table
    table.create_notifications(current_user, seat)
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
        priority: 9).open_graph('join', table)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def mark_complete
    table = Table.find(params[:id])
    if current_user.sitting?(table) && 
      !current_user.already_marked_complete?(table)

      completion_mark = current_user.completion_marks.new
      completion_mark.table_id = table.id
      completion_mark.save
      table.calculate_completion
      if table.complete
        flash[:success] = 'Table complete!'
      else
        flash[:success] = 'You marked this table as complete'
      end
      redirect_to table
    elsif table.complete
      flash[:success] = 'This table already completed'
      redirect_to table
    else
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
  rescue ActiveRecord::RecordNotFound
    redirect_to explore_path
  end

  def start
    @title = @nav_title = 'Start'
    @location = params[:location].nil? ?
      current_user.location : params[:location]
    results = nil
    if params[:term]
      consumer = OAuth::Consumer.new(yelp_consumer_key, yelp_consumer_secret, 
        { site: "http://#{yelp_api_host}" })
      access_token = OAuth::AccessToken.new(consumer, yelp_token, 
        yelp_token_secret)
      limit = 10
      if !params[:location].empty?
        location = URI.escape(params[:location])
      elsif current_user.location
        location = URI.escape(current_user.location)
      else
        location = URI.escape(yelp_default_location)
      end
      term = URI.escape(params[:term])
      path = "/v2/search?limit=#{limit}&location=#{location}&term=#{term}"
      json = access_token.get(path).body
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
