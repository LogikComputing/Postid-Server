# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  from_id           :integer
#  message           :string
#  post_id           :integer
#  notification_type :integer
#  viewed            :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Notification < ActiveRecord::Base
  after_initialize :init

  def init
    self.viewed ||= false
  end

  enum notification_type: [:postid_of_you, :profiled_for_other, :profiled_for_you,
                           :friend_request_received, :friend_request_accepted]

  def as_json(options={})
    options[:except] ||= []
    json = super
    json[:created_at] = self.created_at.to_i
    return json
  end

  def mark_viewed
    self.update_attribute(:viewed, true)
  end
end
