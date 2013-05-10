class AddLatitudeLongitudeRatingReviewCountToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :latitude, :float, default: 0
    add_column :places, :longitude, :float, default: 0
    add_column :places, :rating, :float, default: 0
    add_column :places, :review_count, :integer, default: 0

    add_index :places, :latitude
    add_index :places, :longitude
    add_index :places, :rating
    add_index :places, :review_count
  end
end
