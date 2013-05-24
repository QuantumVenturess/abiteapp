module FacebookHelper

  def app_id
    if Rails.env.production?
      '113847918785782'
    else
      '171528796344918'
    end
  end

  def app_secret
    if Rails.env.production?
      'eae4ebadce8aaeba419703ee1f4dbe8d'
    else
      '78f66ce168ad71d205f730d50e368d46'
    end
  end

  def check_permissions(facebook_id, access_token)
    url = ["https://graph.facebook.com/#{facebook_id}/permissions?", 
      "access_token=#{access_token}"].join('')
    api_call = HTTParty.get(url)
    results = JSON.parse(api_call.to_json)
    true if results['data'][0]['publish_actions'] == 1
  end

  def facebook_scope
    [
      'email',
      'publish_actions',
      'user_location'
      ].join(',')
  end

  def facebook_url
    client_id = app_id
    redirect_uri = facebook_redirect_uri
    response_type = 'token'
    scope = facebook_scope
    state = 10.times.map { rand(10) }.join('')
    ["https://www.facebook.com/dialog/oauth?",
    "client_id=#{client_id}",
    "&redirect_uri=#{redirect_uri}",
    "&scope=#{scope}",
    "&state=#{state}"].join('')
  end

  def facebook_redirect_uri
    if Rails.env.production?
      'http://abiteapp.com/auth'
    else
      if ENV['os'] == 'Windows_NT'
        'http://localhost:3000/auth'
      else
        'http://192.168.1.72:3000/auth'
        'http://localhost:3000/auth'
      end
    end
  end
end