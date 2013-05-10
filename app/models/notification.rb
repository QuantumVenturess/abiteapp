class Notification < ActiveRecord::Base

  validates :user_id, presence: true

  belongs_to :message
  belongs_to :seat
  belongs_to :table
  belongs_to :user

end
