# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  access_token       :string(255)
#  admin              :boolean          default(FALSE)
#  email              :string(255)
#  encrypted_password :string(255)
#  facebook_id        :integer
#  first_name         :string(255)
#  image              :string(255)
#  in_count           :integer          default(0)
#  last_in            :datetime
#  last_name          :string(255)
#  location           :string(255)
#  name               :string(255)
#  salt               :string(255)
#  slug               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
