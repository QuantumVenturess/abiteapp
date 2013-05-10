source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'annotate', '>=2.5.0'
gem 'dalli'
gem 'delayed_job_active_record'
gem 'fb_graph'
gem 'friendly_id'
gem 'geocoder'
gem 'httparty'
gem 'jquery-rails'
gem 'kaminari'
gem 'oauth'
gem 'pg'


group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  if ENV['os'] != 'Windows_NT'
    gem 'thin'
  end
end

group :production do
  gem 'newrelic_rpm'
  gem 'pg'
  gem 'thin'
end