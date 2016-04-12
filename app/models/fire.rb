# == Schema Information
#
# Table name: fires
#
#  id      :integer          not null, primary key
#  user_id :integer
#  post_id :integer
#

class Fire < ActiveRecord::Base
    belongs_to :user
    belongs_to :post
end
