class RemoveAddUniqueIndexForTableIdOnRooms < ActiveRecord::Migration
  def up
    remove_index :rooms, :table_id
    add_index :rooms, :table_id, unique: true
  end

  def down
  end
end
