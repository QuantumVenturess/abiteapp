class CreateCompletionMarks < ActiveRecord::Migration
  def change
    create_table :completion_marks do |t|
      t.integer :table_id
      t.integer :user_id

      t.timestamps
    end

    add_index :completion_marks, [:table_id, :user_id], unique: true
  end
end
