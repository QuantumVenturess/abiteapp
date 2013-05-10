class UsersController < ApplicationController
  before_filter :authenticate

  def show
    @user  = User.find(params[:id])
    seats  = @user.complete
    @seats = seats.page(params[:p])
    @started  = @user.started_count
    @sitting  = @user.sitting_count
    @complete = seats.size
    @title = @nav_title = @user.name
    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to current_user
  end

  def update_location
    latitude  = params[:latitude]
    longitude = params[:longitude]
    if latitude && longitude
      address = Geocoder.address([latitude, longitude])
      if address
        zip = address[/ [0-9]{5}, /][/[0-9]+/]
        if zip
          current_user.update_attribute(:location, zip)
        end
      end
    end
    respond_to do |format|
      format.html {
        render json: zip
      }
      format.js {
        @zip = zip
      }
    end
  end

end
