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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
