# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  from_id    :integer
#  message    :string
#  post_id    :integer
#  type       :integer
#  viewed     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ActiveRecord::Base
  enum type: [:postid_of_you, :profiled_for_other, :profiled_for_you,
                           :friend_request_received, :friend_request_accepted]

  def mark_viewed
    self.update_attribute(:viewed, true)
  end
end
