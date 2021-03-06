class SessionsController < ApplicationController
  before_filter :authenticate, only: :destroy
  before_filter :already_signed_in, only: [:auth, :new]

  def auth
    client_id     = app_id
    client_secret = app_secret
    code          = params[:code]
    redirect_uri  = facebook_redirect_uri
    exchange = ["https://graph.facebook.com/oauth/access_token?",
                "client_id=#{client_id}",
                "&client_secret=#{client_secret}",
                "&code=#{code}",
                "&redirect_uri=#{redirect_uri}"].join('')
    response = HTTParty.get(exchange)
    if response.to_s[/error/]
      flash[:error] = 'Unable to authenticate, please try again'
      redirect_to sign_in_path
    end
    access_token = response.to_s.split('=')[1].split('&')[0]
    api_call = HTTParty.get(
      "https://graph.facebook.com/me?access_token=#{access_token}")
    results = JSON.parse(api_call)
    email       = results['email']
    facebook_id = results['id']
    first_name  = results['first_name']
    image       = "http://graph.facebook.com/#{facebook_id}/picture?type=large"
    last_name   = results['last_name']
    name        = results['name']
    if results['location']
      location = results['location']['name']
    else
      location = results['location']
    end
    user = User.find_by_facebook_id(facebook_id)
    if user
      user.access_token = access_token
      user.save
      sign_in user
      redirect_back_or root_path
#    elsif check_permissions(facebook_id, access_token)
    else
      user = User.new(email: email, 
                      first_name: first_name,
                      image: image,
                      last_name: last_name,
                      location: location,
                      name: name)
      user.access_token = access_token
      user.facebook_id = facebook_id
      if user.save
        sign_in user
        redirect_back_or root_path
      else
        flash[:error] = 'Unable to create user, please try again'
        redirect_to sign_in_path
      end
#    else
#      flash[:notice] = 'Please allow all permissions'
#      redirect_to sign_in_path
    end
  end

  def new
    @title = 'Join'
    @ios   = request.env['HTTP_USER_AGENT'] =~ /ipad|iphone/i
    if @ios
      @ios_link = 'http://appstore.com/biteapp'
      @target   = ''
    else
      @ios_link = 'https://itunes.apple.com/us/app/bite-app/id661010278?mt=8'
      @target   = '_blank'
    end
  end

  def destroy
    sign_out
    clear_return_to
    redirect_to root_path
  end

end
