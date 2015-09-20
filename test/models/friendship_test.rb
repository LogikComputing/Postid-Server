# == Schema Information
#
# Table name: friendships
#
#  id            :integer          not null, primary key
#  friendable_id :integer
#  friend_id     :integer
#  blocker_id    :integer
#  pending       :boolean          default(TRUE)
#

require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
