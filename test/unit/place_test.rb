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

require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
