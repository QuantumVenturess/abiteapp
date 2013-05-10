class ChangeDefaultClosedOnRooms < ActiveRecord::Migration
  def up
    change_column :rooms, :closed, :boolean, default: false
  end

  def down
  end
end
