# == Schema Information
#
# Table name: tables
#
#  id         :integer          not null, primary key
#  date_ready :datetime
#  max_seats  :integer
#  place_id   :integer
#  ready      :boolean
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TableTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
