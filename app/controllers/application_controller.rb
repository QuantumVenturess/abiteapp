class ApplicationController < ActionController::Base
  before_filter :mobile_device

  protect_from_forgery

  include CalendarHelper
  include FacebookHelper
  include MessagesHelper
  include NotificationsHelper
  include PlacesHelper
  include SessionsHelper
  include TablesHelper
  include UsersHelper
  include YelpHelper

  private

    def mobile_device
      @mobile = request.env['HTTP_USER_AGENT'] =~ /mobile|webos/i
    end

end
