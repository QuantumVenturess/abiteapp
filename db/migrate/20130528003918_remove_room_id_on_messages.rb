class RemoveRoomIdOnMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :room_id
  end

  def down
  end
end
