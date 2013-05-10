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

  def photo
    self.image_url.empty? ? '/assets/place.png' : self.image_url
  end

end
