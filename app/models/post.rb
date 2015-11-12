# == Schema Information
#
# Table name: posts
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  image_url          :string           not null
#  view_count         :integer          default(0)
#  heart_count        :integer          default(0)
#  smirk_count        :integer          default(0)
#  fire_count         :integer          default(0)
#  created_ip_address :string           default("")
#  likes              :integer          default(0)
#  likes_needed       :integer          default(0)
#  flagged            :boolean          default(FALSE)
#  approved           :boolean          default(FALSE)
#  deleted            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Post < ActiveRecord::Base
  include NotificationHelper

  has_and_belongs_to_many :users

  def as_json(options={})
    super(:include => :users)
  end

  def add_view
    self.increment!(:view_count)
  end

  def add_heart
    self.increment!(:heart_count)
  end

  def remove_heart
    self.decrement!(:heart_count)
  end

  def add_smirk
    self.increment!(:smirk_count)
  end

  def remove_smirk
    self.decrement!(:smirk_count)
  end

  def add_fire
    self.increment!(:fire_count)
  end

  def remove_fire
    self.decrement!(:fire_count)
  end



  def add_like
    self.increment!(:likes)

    if self.likes > (self.likes_needed / 2)
      self.update_attribute(:approved, true)

      # Notify user that his post was postid
      create_notification(self.user_id, users.first.id, 'Your post for _xUx_ has been profiled', self.id,  Notification.PROFILED_FOR_OTHER)

      # Notify users that they were postid of
      self.users.each do |user|
        create_notification(user.id, self.user_id, '_xUx_ post of you has been profiled', self.id, Notification.PROFILED_FOR_YOU)
      end

      create_notification(u, from, message, post, type)

    end
  end
end
