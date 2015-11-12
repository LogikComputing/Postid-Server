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

  @@POSTID_OF_YOU = 0
  @@PROFILED_FOR_OTHER = 1
  @@PROFILED_FOR_YOU = 2
  @@FRIEND_REQUEST_RECEIVED = 3
  @@FRIEND_REQUEST_ACCEPTED = 4

  def as_json(options={})
    options[:except] ||= []
    json = super
    json[:created_at] = self.created_at.to_i
    return json
  end

  def mark_viewed
    self.update_attribute(:viewed, true)
  end

  def self.POSTID_OF_YOU
    @@POSTID_OF_YOU
  end

  def self.PROFILED_FOR_OTHER
    @@PROFILED_FOR_OTHER
  end

  def self.PROFILED_FOR_YOU
    @@PROFILED_FOR_YOU
  end

  def self.FRIEND_REQUEST_RECEIVED
    @@FRIEND_REQUEST_RECEIVED
  end

  def self.FRIEND_REQUEST_ACCEPTED
    @@FRIEND_REQUEST_ACCEPTED
  end
end
