module YelpHelper

  def yelp_api_host
    'api.yelp.com'
  end

  def yelp_consumer_key
    ENV['YELP_CONSUMER_KEY']
  end

  def yelp_consumer_secret
    ENV['YELP_CONSUMER_SECRET']
  end

  def yelp_default_location
    'san jose'
  end

  def yelp_rating_to_class(rating)
    r = rating.to_f
    if r == 0.0
      'zero'
    elsif r == 1.0
      'one'
    elsif r == 1.5
      'onePointFive'
    elsif r == 2.0
      'two'
    elsif r == 2.5
      'twoPointFive'
    elsif r == 3.0
      'three'
    elsif r == 3.5
      'threePointFive'
    elsif r == 4.0
      'four'
    elsif r == 4.5
      'fourPointFive'
    elsif r == 5.0
      'five'
    end
  end

  def yelp_token
    ENV['YELP_TOKEN']
  end

  def yelp_token_secret
    ENV['YELP_TOKEN_SECRET']
  end

end
