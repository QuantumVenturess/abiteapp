class ApplicationController < ActionController::Base
  protect_from_forgery

  include FacebookHelper
  include PlacesHelper
  include SessionsHelper
  include UsersHelper
  include YelpHelper
end
