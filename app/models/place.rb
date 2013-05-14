# == Schema Information
#
# Table name: places
#
#  id           :integer          not null, primary key
#  address      :string(255)
#  city         :string(255)
#  image_url    :string(255)
#  name         :string(255)
#  phone        :string(255)
#  postal_code  :integer
#  slug         :string(255)
#  state_code   :string(255)
#  yelp_id      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  latitude     :float            default(0.0)
#  longitude    :float            default(0.0)
#  rating       :float            default(0.0)
#  review_count :integer          default(0)
#

class Place < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :address, 
                  :city, 
                  :image_url, 
                  :latitude,
                  :longitude,
                  :name, 
                  :phone, 
                  :postal_code,
                  :rating,
                  :review_count, 
                  :state_code

  validates :name, presence: true
  validates :yelp_id, presence: true
  validates_uniqueness_of :yelp_id

  has_many :tables, dependent: :destroy

  def facebook_meta_image
    self.s3_url ? self.s3_url : self.photo
  end

  def original_image_path
    name = self.yelp_id + '.jpg'
    directory = 'public/images/original'
    File.join(directory, name)
  end

  def photo
    self.image_url.empty? ? '/assets/place.png' : self.image_url
  end

  def resized_image_path
    name = self.yelp_id + '.jpg'
    directory = 'public/images/resized'
    File.join(directory, name)
  end

  def save_image
    if !self.image_url.empty?
      begin
        image = open(self.image_url).read
      rescue
        image = nil
        puts 'Place save_image: No such file or directory'
      end
      if !image.nil?
        File.open(self.original_image_path, 'wb') do |file|
          file.write image
        end
        self.resize
      end
    end
  end

  def resize
    begin
      image = MiniMagick::Image.open(self.original_image_path)
      image.resize '200x200'
      image.format 'jpg'
      image.write self.resized_image_path
      s3 = AWS::S3.new(
        access_key_id: 'AKIAIXM2DMH4M2PAT5TA',
        secret_access_key: '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')
      bucket = s3.buckets['abiteapp']
      obj = bucket.objects["#{self.yelp_id}.jpg"]
      obj.write(Pathname.new(self.resized_image_path))
      obj.acl = :public_read
      File.delete(self.original_image_path)
      File.delete(self.resized_image_path)
    rescue
      puts 'Place resize: No such file or directory'
    end
    url = "http://s3.amazonaws.com/abiteapp/#{self.yelp_id}.jpg"
    begin
      image = open(url).read
      self.s3_url = url
      self.save
    rescue
      puts 'Place resize: Cannot open Amazon AWS S3 URL'
    end
  end

end
