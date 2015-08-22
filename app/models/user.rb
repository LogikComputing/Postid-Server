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