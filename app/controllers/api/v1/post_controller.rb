class Api::V1::PostController < Api::V1::ApiController

  def make_post
    authenticate_request
    make_post_params

    url_key = params[:post][:url_key]
    user_ids = params[:post][:user_id_array]

    new_post = Post.create(user_id: @user.id, image_url: url_key, created_ip_address: request.remote_ip)
    if !new_post.save
      render json: {error: 'Unable to save new post', messages: @user.errors.full_messages, status: :precondition_failed},
             status: :precondition_failed and return
    end

    render json: {status: :created, message: 'Post made'}, status: :created
  end

  private
  def make_post_params
    params.require(:post).permit(:url_key, :user_id_array)
  end

end

#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  image_url          :string           not null
#  view_count         :integer          default(0)
#  heart_count        :integer          default(0)
#  smirk_count        :integer          default(0)
#  fire_count         :integer          default(0)
#  created_ip_address :string           default("")
#  likes              :integer          default(0)
#  likes_needed       :integer          default(0)
#  flagged            :boolean          default(FALSE)
#  approved           :boolean          default(FALSE)
#  deleted            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
