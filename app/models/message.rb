class Message < ActiveRecord::Base

  attr_accessible :content

  validates :content, presence: true
  validates :room_id, presence: true
  validates :user_id, presence: true

  belongs_to :room
  belongs_to :user

  has_many :notifications, dependent: :destroy
end
