class NotificationsController < ApplicationController
  before_filter :authenticate

  def clear_news
    current_user.news_viewed
    respond_to do |format|
      format.html {
        redirect_to news_path
      }
      format.js
    end
  end

  def forward
    notification = Notification.find(params[:id])
    notification.viewed = true
    notification.save
    if notification.message
      redirect_to notification.message.room
    elsif notification.seat
      redirect_to notification.seat.table
    elsif notification.table && notification.table.room
      redirect_to notification.table.room
    else
      redirect_to news_path
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to news_path
  end

  def news
    @title = @nav_title = 'News'
    @notifications = current_user.new_news.page(params[:p]).per(20)
    respond_to do |format|
      format.html
      format.js
    end
  end

end