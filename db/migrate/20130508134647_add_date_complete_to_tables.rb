class AddDateCompleteToTables < ActiveRecord::Migration
  def change
    add_column :tables, :date_complete, :datetime

    add_index :tables, :date_complete
  end
end
