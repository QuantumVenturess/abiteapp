class NotificationsController < ApplicationController
  before_filter :authenticate

  def clear_news
    current_user.news_viewed
    respond_to do |format|
      format.html {
        redirect_to news_path
      }
      format.js
      format.json
    end
  end

  def forward
    notification = Notification.find(params[:id])
    notification.viewed = true
    notification.save
    if notification.message
      redirect_to notification.message.table
    elsif notification.seat
      redirect_to notification.seat.table
    elsif notification.table
      redirect_to notification.table
    else
      redirect_to news_path
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to news_path
  end

  def news
    @title = @nav_title = 'News'
    @notifications = current_user.new_news.page(params[:p]).per(15)
    respond_to do |format|
      format.html
      format.js
      format.json {
        hash = {
          notifications: notifications_to_json(@notifications),
          pages: @notifications.num_pages
        }
        render json: hash
      }
    end
  end

  def news_unviewed
    respond_to do |format|
      format.html {
        redirect_to news_path
      }
      format.json {
        hash = {
          notifications_unviewed: current_user.news.size
        }
        render json: hash
      }
    end
  end

end
