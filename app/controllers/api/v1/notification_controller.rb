class Api::V1::NotificationController < Api::V1::ApiController

  #  id         :integer          not null, primary key
  #  user_id    :integer
  #  from_id    :integer
  #  message    :string
  #  post_id    :integer
  #  type       :integer
  #  viewed     :boolean
  #  created_at :datetime         not null
  #  updated_at :datetime         not null


  def fetch_notifications
    authenticate_request
    params.require(:notification).permit(:min_id)

    min_id = params[:notification][:min_id].to_i
    relevant_notifications = Array.new

    @user.notifications.select{|notification| notification.id > min_id}.each do |notification|
      relevant_notifications.append(notification)
    end

    max_id = Notification.last.id

    render json: {status: :ok, message: 'Notifications fetched', notifications: relevant_notifications, max_id: max_id}, status: :ok

    # return max_id for post table
  end

  def mark_notification_viewed
    authenticate_request
    params.require(:notification).permit(:notification_id)

    notification_id = params[:notification][:notification_id]
    notification = Notification.find(notification_id)

    if notification.blank?
      render json: {error: 'Unable to find notification', messages: @user.errors.full_messages, status: :precondition_failed},
             status: :precondition_failed and return
    end

    notification.mark_viewed()

    render json: {status: :created, message: 'Notification viewed', notification:notification}, status: :created
  end
end
