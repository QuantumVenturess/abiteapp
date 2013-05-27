class AddTableIdOnMessages < ActiveRecord::Migration
  def up
    add_column :messages, :table_id, :integer
    add_index :messages, :table_id
  end

  def down
  end
end
