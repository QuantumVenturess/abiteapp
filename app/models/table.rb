# == Schema Information
#
# Table name: tables
#
#  id         :integer          not null, primary key
#  date_ready :datetime
#  max_seats  :integer
#  place_id   :integer
#  ready      :boolean
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Table < ActiveRecord::Base
  
  attr_accessible :max_seats, :ready, :start_date

  validates :max_seats, inclusion: { in: 2..18 }
  validates :place_id, presence: true
  validates :user_id, presence: true

  belongs_to :place
  belongs_to :user

  has_many :completion_marks, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :seats, dependent: :destroy
  has_one :room, dependent: :destroy

  scope :waiting, where(complete: false, ready: false)

  def calculate_completion
    threshold = (self.max_seats / 2.0).floor + 1
    if self.completion_marks.size >= threshold
      self.complete = true
      self.date_complete = Time.zone.now
      self.save
    end
  end

  def calculate_completion_proximity(lat, lon, user)
    if lat && lon &&
       user == self.user && 
       user.sitting?(self) && 
       !user.already_marked_complete?(self)

      place_coords = [self.place.latitude, self.place.longitude]
      user_coords  = [lat.to_f, lon.to_f]
      miles = Geocoder::Calculations.distance_between(place_coords, user_coords)
      if miles <= 0.5
        completion_mark = user.completion_marks.new
        completion_mark.table_id = self.id
        completion_mark.save
        self.complete = true
        self.date_complete = Time.zone.now
        self.save
      end
    end
  end

  def check_ready
    if self.seats.size >= self.max_seats
      if !self.ready
        self.date_ready = Time.zone.now
        self.ready = true
        self.save
        self.seats.each do |seat|
          if Rails.env.production?
            UserMailer.delay.table_ready(self, seat.user)
          else
            UserMailer.table_ready(self, seat.user).deliver
          end
        end
      end
    end
  end

  def create_notifications(user, table_seat)
    self.seats.each do |seat|
      # Create notification for user sitting at table
      if seat.user != user
        seat_n = seat.user.notifications.new
        seat_n.seat_id = table_seat.id
        seat_n.save
      end
      # Create notification if table is ready
      if self.seats.size >= self.max_seats
        table_n = seat.user.notifications.new
        table_n.table_id = self.id
        table_n.save
      end
    end
  end

  def create_room
    room = nil
    if self.seats.size >= self.max_seats
      self.date_ready = Time.zone.now
      self.ready = true
      self.save
      # If no room exists, create one
      if self.room.nil?
        room = Room.new
        room.table_id = self.id
        room.save
      end
    end
    room
  end

end
