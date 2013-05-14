class AddColumnS3UrlOnPlaces < ActiveRecord::Migration
  def up
    add_column :places, :s3_url, :string
    
    add_index :places, :s3_url
  end

  def down
  end
end
