class ChangeReadyDefaultOnTables < ActiveRecord::Migration
  def up
    change_column :tables, :ready, :boolean, default: false
  end

  def down
  end
end
