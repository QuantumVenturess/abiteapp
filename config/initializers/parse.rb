if Rails.env.production?
  require 'parse-ruby-client'

  Parse.init application_id: ENV['PARSE_APPLICATION_ID'],
                    api_key: ENV['PARSE_API_KEY']
end