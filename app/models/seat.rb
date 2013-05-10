# == Schema Information
#
# Table name: seats
#
#  id         :integer          not null, primary key
#  table_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Seat < ActiveRecord::Base

  validates :table_id, presence: true
  validates :user_id, presence: true

  belongs_to :table
  belongs_to :user

  has_many :notifications, dependent: :destroy

end
