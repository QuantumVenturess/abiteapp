module FacebookHelper

  def app_id
    ENV['FACEBOOK_APP_ID']
  end

  def app_secret
    ENV['FACEBOOK_APP_SECRET']
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
