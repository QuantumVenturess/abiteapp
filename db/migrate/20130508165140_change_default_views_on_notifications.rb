class ChangeDefaultViewsOnNotifications < ActiveRecord::Migration
  def up
    change_column :notifications, :viewed, :boolean, default: false
  end

  def down
  end
end
