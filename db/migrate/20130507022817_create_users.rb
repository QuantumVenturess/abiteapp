class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :access_token
      t.boolean :admin
      t.string :email
      t.string :encrypted_password
      t.integer :facebook_id
      t.string :first_name
      t.string :image
      t.integer :in_count
      t.datetime :last_in
      t.string :last_name
      t.string :location
      t.string :name
      t.string :salt
      t.string :slug

      t.timestamps
    end

    add_index :users, :access_token
    add_index :users, :admin
    add_index :users, :email, unique: true
    add_index :users, :facebook_id, unique: true
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :location
    add_index :users, :name
    add_index :users, :salt
    add_index :users, :slug, unique: true
  end
end
