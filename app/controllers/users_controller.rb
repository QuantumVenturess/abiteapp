class UsersController < ApplicationController
  before_filter :authenticate, except: [:authenticate_bite_app, 
    :bite_access_token]

  def authenticate_bite_app
    access_token = params[:access_token]
    email        = params[:email]
    facebook_id  = params[:facebook_id]
    first_name   = params[:first_name]
    image        = "http://graph.facebook.com/#{facebook_id}/picture?type=large"
    last_name    = params[:last_name]
    name         = "#{first_name} #{last_name}"
    location     = params[:location]
    # Verification
    partial = Rails.env.production? ? 'CAABni0jB9PYBA' : 'CAACcASj5klYBA'
    match   = access_token[Regexp.new(partial)]
    user    = User.find_by_facebook_id(facebook_id)
    if match
      if user
        user.access_token = access_token
        user.in_count += 1
        user.last_in = Time.zone.now
      else
        user = User.new(email: email,
                        first_name: first_name,
                        image: image,
                        last_name: last_name,
                        location: location,
                        name: name)
        user.access_token = access_token
        user.facebook_id  = facebook_id
      end
      if user.save
        bite_token = "#{user.id}00000#{user.token}"
      else
        bite_token = 'user save false'
      end
    else
      bite_token = 'access token no match'
    end
    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.json {
        hash = {
          bite_access_token: bite_token,
          id: user.id,
          read_tutorial: user.read_tutorial
        }
        render json: hash
      }
    end
  end

  def bite_access_token
    token = params[:token]
    partial = Rails.env.production? ? 'CAABni0jB9PYBA' : 'CAACcASj5klYBA'
    if token && token.split(partial).count == 2
      facebook_id = token.split(partial)[0]
      last_name = token.split(partial)[1]
      user = User.find_by_facebook_id_and_last_name(facebook_id, last_name)
    end
    bite_token = user ? "#{user.id}00000#{user.token}" : 'user nil'
    dictionary = {
      bite_access_token: bite_token
    }
    render json: dictionary
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
      format.json {
        hash = {
          read_tutorial: current_user.read_tutorial
        }
        render json: hash
      }
    end
  end

  def show
    @user     = User.find(params[:id])
    @title    = @nav_title = @user.name
    tables    = @user.complete
    @tables   = Kaminari.paginate_array(tables).page(params[:p]).per(10)
    @started  = @user.started_count
    @sitting  = @user.sitting_count
    @complete = tables.size
    respond_to do |format|
      format.html
      format.js
      format.json {
        hash = {
          complete_count: @complete,
          pages: @tables.num_pages,
          sitting_count: @sitting,
          started_count: @started,
          tables: tables_to_json(@tables)
        }
        render json: hash
      }
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
