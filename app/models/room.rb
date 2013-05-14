class Room < ActiveRecord::Base

  validates :table_id, presence: true
  validates_uniqueness_of :table_id

  belongs_to :table

  has_many :messages, dependent: :destroy

  def create_notifications(message)
    self.table.seats.each do |seat|
      if seat.user != message.user
        notification = seat.user.notifications.new
        notification.message_id = message.id
        notification.save
      end
    end
  end
end
