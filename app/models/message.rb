class Message < ActiveRecord::Base

  attr_accessible :content

  validates :content, presence: true
  validates :table_id, presence: true
  validates :user_id, presence: true

  belongs_to :table
  belongs_to :user

  has_many :notifications, dependent: :destroy
end
