# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string           not null
#  last_name       :string           not null
#  username        :string           not null
#  email           :string           not null
#  password_hash   :string           not null
#  token           :string           default("")
#  check_ins       :integer          default(1)
#  posts_created   :integer          default(1)
#  last_ip_address :string           default("")
#  admin           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  phone_number    :string           default("")
#  image_url       :string           default("")
#

class User < ActiveRecord::Base
  include BCrypt
  include Amistad::FriendModel

  has_and_belongs_to_many :posts
  has_many :notifications

  has_and_belongs_to_many :hearts, class_name: 'Post'
  has_and_belongs_to_many :smirks, class_name: 'Post'
  has_and_belongs_to_many :fires, class_name: 'Post'

  has_and_belongs_to_many :likes, class_name: 'Post'

  before_create :reset_token

  def name
    "#{first_name} #{last_name}"
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def update_ip(request)
    self.update_attribute(:last_ip_address, request.remote_ip)
  end

  def add_checkin
    self.increment!(:check_ins)
  end

  def reset_token
    self.token = SecureRandom.uuid.gsub(/\-/,'')
  end

  def friend_ids
    tmp = self.friends
    return tmp.map{|friend| friend.id}
  end

  def pending_ids
    tmp = self.pending_invited
    return tmp.map{|friend| friend.id}
  end

  def request_ids
    tmp = self.pending_invited_by
    return tmp.map{|friend| friend.id}
  end

  def friend_state_ids
    return {'friends':self.friend_ids, 'pending':self.pending_ids, 'requests':self.request_ids}
  end

  def friend_count
    return self.friends.count
  end


  # def is_friends?(user)
  #   return self.friends.exists?(user) || self.inverse_friends.exists?(user)
  # end
  #
  # def is_pending_friend?(user)
  #   return self
  # end
  #
  # def add_friend(friend_id)
  #   @friendship = self.friendships.build(:friend_id => friend_id)
  #   return @friendship.save
  # end
  #
  # def remove_friend(friend_id)
  #   @friendship = self.friendships.find(friend_id)
  #   @friendship.destroy
  # end

end
