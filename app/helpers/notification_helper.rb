#  id         :integer          not null, primary key
#  user_id    :integer
#  from_id    :integer
#  message    :string
#  post_id    :integer
#  type       :integer
#  viewed     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not nul
#

module NotificationHelper

  ## Types
  ## 0 - postid photo of you
  ## 1 - post profiled
  ## 2 - profiled for you
  ## 3 - friend request
  ## 4 - friend request accepted

  def create_notification(user_id, from_id, message, post_id, type)
    Notification.create(user_id: user_id, from_id: from_id, message: message,
                        post_id: post_id, type:type)
  end

end
