class Api::V1::PostController < Api::V1::ApiController

  def make_post
    authenticate_request
    make_post_params

    url_key = params[:post][:url_key]
    user_ids = params[:post][:user_id_array]
    likes_needed = 0

    new_post = Post.create(user_id: @user.id, image_url: url_key, created_ip_address: request.remote_ip)
    if !new_post.save
      render json: {error: 'Unable to save new post', messages: @user.errors.full_messages, status: :precondition_failed},
             status: :precondition_failed and return
    end

    user_ids.each do |id|
      tmp_user = User.find(id)
      if tmp_user.present?
        friend_count = tmp_user.friend_count
        if friend_count > likes_needed
          likes_needed = friend_count
        end

        tmp_user.posts << new_post
        tmp_user.save
      end
    end

    new_post.update_attribute(:likes_needed, likes_needed)


    render json: {status: :created, message: 'Post made'}, status: :created
  end

  def fetch_posts
    authenticate_request
    fetch_posts_params

    min_id = params[:post][:min_id].to_i
    relevant_posts = Array.new

    @user.posts.select{|post| post.id > min_id}.each do |post|
      relevant_posts.append(post)
    end

    @user.friends.each do |friend|
      friend.posts.select{|post| post.id > min_id}.each do |post|
        relevant_posts.append(post)
      end
    end

    max_id = Post.last.id

    render json: {status: :ok, message: 'Posts fetched', posts: relevant_posts, max_id: max_id}, status: :ok

    # return max_id for post table
  end

  private
  def make_post_params
    params.require(:post).permit(:url_key, :user_id_array)
  end

  def fetch_posts_params
    params.require(:post).permit(:min_id)
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
