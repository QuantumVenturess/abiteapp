class ChangeDefaultAdminAndInCountOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :admin, :boolean, default: false
    change_column :users, :in_count, :integer, default: 0
  end

  def down
  end
end
