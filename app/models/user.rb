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

  before_create :reset_token
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

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
