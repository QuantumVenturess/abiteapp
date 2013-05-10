class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :table_id
      t.integer :user_id

      t.timestamps
    end

    add_index :seats, [:table_id, :user_id], unique: true
  end
end
