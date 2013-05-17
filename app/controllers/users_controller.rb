class UsersController < ApplicationController
  before_filter :authenticate, except: :bite_access_token

  def bite_access_token
    token = params[:token]
    partial = Rails.env.production? ? 'CAABni0jB9PYBA' : 'CAACcASj5klYBA'
    if token && token.split(partial).count == 2
      facebook_id = token.split(partial)[0]
      last_name = token.split(partial)[1]
      user = User.find_by_facebook_id_and_last_name(facebook_id, last_name)
    end
    bite_token = user ? "#{user.id}00000#{user.token}" : ''
    render json: bite_token
  end

  def read_tutorial
    current_user.read_tutorial = true
    current_user.save
    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.js {
        render nothing: true
      }
    end
  end

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
