class Room < ActiveRecord::Base

  validates :table_id, presence: true
  validates_uniqueness_of :table_id

  belongs_to :table

  has_many :messages, dependent: :destroy
end
