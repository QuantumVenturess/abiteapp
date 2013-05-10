class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.boolean :closed
      t.integer :table_id

      t.timestamps
    end

    add_index :rooms, :table_id
  end
end
