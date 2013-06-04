class PlacesController < ApplicationController
  before_filter :authenticate

  def create
    address      = params[:address]
    city         = params[:city]
    image_url    = params[:image_url]
    latitude     = params[:latitude]
    longitude    = params[:longitude]
    name         = params[:name]
    phone        = params[:phone]
    postal_code  = params[:postal_code]
    rating       = params[:rating]
    review_count = params[:review_count]
    state_code   = params[:state_code]
    yelp_id      = params[:yelp_id]

    # Create or update place
    place = Place.find_by_yelp_id(yelp_id)
    if place
      place.address      = address if place.address != address
      place.city         = city if place.city != city
      place.image_url    = image_url if place.image_url != image_url
      place.latitude     = latitude if place.latitude != latitude
      place.longitude    = longitude if place.longitude != longitude
      place.name         = name if place.name != name
      place.phone        = phone if place.phone != phone
      place.postal_code  = postal_code if place.postal_code != postal_code
      place.rating       = rating if place.rating != rating
      place.review_count = review_count if place.review_count != review_count
      place.state_code   = state_code if place.state_code != state_code
      place.yelp_id      = yelp_id if place.yelp_id != yelp_id
    else
      place = Place.create(address: address,
                           city: city,
                           image_url: image_url,
                           latitude: latitude,
                           longitude: longitude,
                           name: name,
                           phone: phone,
                           postal_code: postal_code,
                           rating: rating,
                           review_count: review_count,
                           state_code: state_code)
      place.yelp_id = yelp_id
    end
    place.save

    # Create table and initial seat
    if params[:max_seats].empty?
      if params[:max_seats_hidden].empty?
        max_seats = 2
      else
        max_seats = params[:max_seats_hidden]
      end
    elsif params[:max_seats].to_i > 20
      max_seats = 20
    elsif params[:max_seats].to_i < 2
      max_seats = 2
    else
      max_seats = params[:max_seats]
    end
    table            = current_user.tables.new
    table.max_seats  = max_seats
    table.place_id   = place.id
    if params[:start_day] && !params[:start_day].empty? &&
      params[:start_hour] && !params[:start_hour].empty? &&
      params[:start_minute] && !params[:start_minute].empty?

      day    = params[:start_day].to_date
      hour   = params[:start_hour].to_i
      minute = params[:start_minute].to_i
      date   = DateTime.new(day.year, day.month, day.day, hour, minute)
      # Adjust time zone offset
      pdt    = ActiveSupport::TimeZone.new('Pacific Time (US & Canada)')
      date   = date - (pdt.now.formatted_offset.to_i).hour
      table.start_date = date
    end
    table.save
    seat            = current_user.seats.new
    seat.table_id   = table.id
    seat.save
    # Download place image and upload to Amazon S3
    if Rails.env.production?
      place.delay(queue: 'save_image', 
        priority: 0).save_image
    else
      # place.save_image
    end
    respond_to do |format|
      format.html {
        if table.start_date
          redirect_to table
        else
          redirect_to date_table_path(table)
        end
      }
      format.json {
        # Data sent from iOS app
        # FB open graph action
        if Rails.env.production?
          current_user.delay(queue: 'open_graph', 
            priority: 10).open_graph('start', table)
        end
        render json: table_to_json(table)
      }
    end
  end

end
