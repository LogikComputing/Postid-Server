# == Schema Information
#
# Table name: smirks
#
#  id      :integer          not null, primary key
#  user_id :integer
#  post_id :integer
#

class Smirk < ActiveRecord::Base
    belongs_to :user
    belongs_to :post
end
