class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.datetime :date_ready
      t.integer :max_seats
      t.integer :place_id
      t.boolean :ready
      t.integer :user_id

      t.timestamps
    end

    add_index :tables, :date_ready
    add_index :tables, :max_seats, default: 4
    add_index :tables, :place_id
    add_index :tables, :ready, default: false
    add_index :tables, :user_id
  end
end
