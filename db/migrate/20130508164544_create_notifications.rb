class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :seat_id
      t.integer :table_id
      t.integer :user_id
      t.boolean :viewed

      t.timestamps
    end

    add_index :notifications, :seat_id
    add_index :notifications, :table_id
    add_index :notifications, :user_id
    add_index :notifications, :viewed, default: false
  end
end
