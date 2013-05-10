class AddColumnCompleteToTables < ActiveRecord::Migration
  def change
    add_column :tables, :complete, :boolean, default: false
  end
end
