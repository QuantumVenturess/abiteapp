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
      max_seats = 4
    elsif params[:max_seats].to_i > 16
      max_seats = 16
    elsif params[:max_seats].to_i < 2
      max_seats = 2
    else
      max_seats = params[:max_seats]
    end
    table           = current_user.tables.new
    table.max_seats = max_seats
    table.place_id  = place.id
    table.save
    seat          = current_user.seats.new
    seat.table_id = table.id
    seat.save
    # FB open graph action
    if Rails.env.production?
      current_user.delay(queue: 'open_graph', 
        priority: 9).open_graph('start', table)
    end
    flash[:success] = 'Table started'
    redirect_to table
  end

end
