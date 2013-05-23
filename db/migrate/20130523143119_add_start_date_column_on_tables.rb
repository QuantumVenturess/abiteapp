class AddStartDateColumnOnTables < ActiveRecord::Migration
  def up
    add_column :tables, :start_date, :datetime
    add_index :tables, :start_date
  end

  def down
  end
end
