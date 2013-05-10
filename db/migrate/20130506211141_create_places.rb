class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :address
      t.string :city
      t.string :image_url
      t.string :name
      t.string :phone
      t.integer :postal_code
      t.string :slug
      t.string :state_code
      t.string :yelp_id

      t.timestamps
    end

    add_index :places, :address
    add_index :places, :city
    add_index :places, :name
    add_index :places, :phone
    add_index :places, :postal_code
    add_index :places, :slug, unique: true
    add_index :places, :state_code
    add_index :places, :yelp_id, unique: true
  end
end
