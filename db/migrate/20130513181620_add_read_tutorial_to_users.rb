class AddReadTutorialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :read_tutorial, :boolean, default: false

    add_index :users, :read_tutorial
  end
end
