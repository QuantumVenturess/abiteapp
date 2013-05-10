class AddIndexOnRoomsAndMessageIdOnNotifications < ActiveRecord::Migration
  def up
    add_column :notifications, :message_id, :integer

    add_index :notifications, :message_id
    add_index :rooms, :closed
  end

  def down
  end
end
