class CompletionMark < ActiveRecord::Base

  validates :table_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :table_id, scope: [:user_id]

  belongs_to :table
  belongs_to :user

end
