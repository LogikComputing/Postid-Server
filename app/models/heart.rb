# == Schema Information
#
# Table name: hearts
#
#  id      :integer          not null, primary key
#  user_id :integer
#  post_id :integer
#

class Heart < ActiveRecord::Base
    belongs_to :user
    belongs_to :post
end
