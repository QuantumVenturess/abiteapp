class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :room_id
      t.integer :user_id

      t.timestamps
    end

    add_index :messages, :room_id
    add_index :messages, :user_id
  end
end
