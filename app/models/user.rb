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
#

class User < ActiveRecord::Base
  include BCrypt
  before_create :reset_token

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
end
