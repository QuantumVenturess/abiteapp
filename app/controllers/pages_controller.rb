class PagesController < ApplicationController

  def about
    @title = 'About'
  end

  def test
    if params[:term]
      consumer_key = 'oCdM9xNcKA_F483fK6jWFw'
      consumer_secret = 'bWjkxPqXebFvCXPwImxUaJRee4k'
      token = 'Z00lrMFwppxUcD0Y2xLKBrxqQaS88cl4'
      token_secret = 'WII0zh9ffeXNYKtQehG6CU5fKj4'

      api_host = 'api.yelp.com'

      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, 
        { site: "http://#{api_host}" })
      access_token = OAuth::AccessToken.new(consumer, token, token_secret)


      limit = 5
      if !params[:location].empty?
        location = URI.escape(params[:location])
      elsif current_user.location
        location = URI.escape(current_user.location)
      else
        location = URI.escape('san diego')
      end
      term = URI.escape(params[:term])

      path = "/v2/search?limit=#{limit}&location=#{location}&term=#{term}"

      json = access_token.get(path).body
      all     = JSON.parse(json)
      @result = all['businesses']
    end
  end

  def yelp
    if params[:term]
      consumer_key = 'oCdM9xNcKA_F483fK6jWFw'
      consumer_secret = 'bWjkxPqXebFvCXPwImxUaJRee4k'
      token = 'Z00lrMFwppxUcD0Y2xLKBrxqQaS88cl4'
      token_secret = 'WII0zh9ffeXNYKtQehG6CU5fKj4'

      api_host = 'api.yelp.com'

      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, 
        { site: "http://#{api_host}" })
      access_token = OAuth::AccessToken.new(consumer, token, token_secret)


      limit = 5
      if params[:location]
        location = URI.escape(params[:location])
      elsif current_user.location
        location = URI.escape(current_user.location)
      else
        location = URI.escape('san diego')
      end
      term = URI.escape(params[:term])

      path = "/v2/search?limit=#{limit}&location=#{location}&term=#{term}"

      @json = access_token.get(path).body
    end
    render layout: false
  end

end
