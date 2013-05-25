# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  access_token       :string(255)
#  admin              :boolean          default(FALSE)
#  email              :string(255)
#  encrypted_password :string(255)
#  facebook_id        :integer
#  first_name         :string(255)
#  image              :string(255)
#  in_count           :integer          default(0)
#  last_in            :datetime
#  last_name          :string(255)
#  location           :string(255)
#  name               :string(255)
#  salt               :string(255)
#  slug               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class User < ActiveRecord::Base
  include FacebookHelper
  include Rails.application.routes.url_helpers

  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :email, 
                  :first_name,
                  :image,
                  :last_name,
                  :location,
                  :name

  validates :email, presence: true
  validates :facebook_id, presence: true
  validates :name, presence: true

  has_many :completion_marks, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :seats, dependent: :destroy
  has_many :tables, dependent: :destroy

  def already_marked_complete?(table)
    true if self.completion_marks.find_by_table_id(table.id)
  end

  def self.authenticate_with_token(id, token)
    if id == 0 && token
      id    = token.split('00000')[0]
      token = token.split('00000')[1]
    end
    user = User.find(id)
    user.token == token ? user : nil if user
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def complete
    self.seats.joins(:table).order('date_complete DESC').where(tables: 
      { complete: true })
  end

  def new_news
    self.notifications.order('created_at DESC').limit(20)
  end

  def news
    self.notifications.where(viewed: false)
  end

  def news_viewed
    self.news.each do |notification|
      notification.viewed = true
      notification.save
    end
  end

  def open_graph(action, object)
    access_token = self.access_token
    url = ["https://graph.facebook.com/me/permissions?", 
      "access_token=#{access_token}"].join('')
    api_call = HTTParty.get(url)
    results = JSON.parse(api_call.to_json)
    if results['data'][0]['publish_actions'] == 1
      namespace = 'abiteapp'
      table = "http://abiteapp.com#{table_path(object)}/permalink"
      story = ["https://graph.facebook.com/me/#{namespace}:#{action}?", 
        "access_token=#{access_token}&", 
        "method=POST&",
        "table=#{table}"].join('')
      post = HTTParty.post(story)
    end
  end

  def photo
    self.image.empty? ? '/assets/user_default.png' : self.image
  end

  def seat_at_table(table)
    if self.sitting?(table)
      table.seats.where(user_id: self.id).first
    end
  end

  def sitting?(table)
    self.seats.find_by_table_id(table.id)
  end

  def sitting_count
    self.seats.joins(:table).where(tables: { complete: false }).size
  end

  def sitting_ready
    self.seats.joins(:table).order('start_date ASC').where(
      'start_date >= ? AND complete = ? AND ready = ?', 
      Time.zone.now.to_date, false, true)
  end

  def sitting_waiting
    self.seats.joins(:table).order('start_date ASC').where(
      'start_date >= ? AND complete = ?', Time.zone.now - (24 * 3600), false)
  end

  def started_count
    self.tables.size
  end

  def tables_not_sitting
    seat_ids = 
      self.seats.select(
        :table_id).map { |seat| seat.table_id }.append(0).join(', ')
    Table.waiting.where("start_date >= ? AND id NOT IN (#{seat_ids})", 
      Time.zone.now - (24 * 3600)).order('start_date ASC')
  end

  def token
    if self.access_token
      at = self.access_token
      at[4] + at[8] + at[12] + at[21] + at[24]
    end
  end

end
