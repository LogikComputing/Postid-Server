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

      create_notification(id, @user.id, "#{@user.username} postid a picture of you", new_post.id, Notification.POSTID_OF_YOU)
    end


    new_post.update_attribute(:likes_needed, likes_needed)


    render json: {status: :created, message: 'Post made'}, status: :created
  end

  def fetch_posts
    authenticate_request
    fetch_posts_params

    min_id = params[:post][:min_id].to_i
    min_id = 0
    relevant_posts = Array.new

    @user.posts.select{|post| post.id > min_id}.each do |post|
      relevant_posts.append(post)
    end

    @user.friends.each do |friend|
      friend.posts.select{|post| post.id > min_id}.each do |post|
        relevant_posts.append(post)
      end
    end

    max_id = Post.last ? Post.last.id : 0

    if relevant_posts.size > 0
      relevant_posts.sort_by! {|post| -post.id}
    end

    render json: {status: :ok, message: 'Posts fetched', posts: relevant_posts, max_id: max_id}, status: :ok

    # return max_id for post table
  end

  def fetch_posts_for_user
    authenticate_request
    fetch_posts_for_user_params

    user_id = params[:user_id]

    relevant_posts = Array.new

    @user.friends.each do |friend|
      friend.posts.each do |post|
        post.users.each do |user|
          if user.id == @user.id
            relevant_posts.append(post)
          end
        end
      end
    end

    if relevant_posts.size > 0
      relevant_posts.sort_by! {|post| -post.id}
    end

    render json: {status: :ok, message: 'Posts fetched', posts: relevant_posts}, status: :ok

  end

  def like_post
    authenticate_request
    like_post_params

    post_id = params[:post][:post_id]
    post = Post.find(post_id)

    if post.blank?
        render json: {error: 'Unable to find post', messages: @user.errors.full_messages, status: :precondition_failed},
          status: :precondition_failed and return
    end

    post.add_like()
    post.save()

    render json: {status: :created, message: 'Post liked', post:post}, status: :created

  end

  def comment_post
    authenticate_request
    comment_post_params

    post_id = params[:post][:post_id]
    comment_type = params[:post][:type]
    increment_value = params[:post][:increment]

    post = Post.find(post_id)

    if post.blank?
      render json: {error: 'Unable to find post', messages: @user.errors.full_messages, status: :precondition_failed},
             status: :precondition_failed and return
    end

    if comment_type == 'HEART' 
      if increment_value > 0
        heart = Heart.where(user_id: @user.id).where(post_id: post.id)
        if not heart.present?
          heart = @user.hearts << Heart.create(post)
        end

        post.add_heart
      else
        #TODO remove hearts

        post.remove_heart
      end
    elsif comment_type == 'FIRE'
      if increment_value > 0
        post.add_fire
      else
        post.remove_fire
      end
    elsif comment_type == 'SMIRK'
      if increment_value > 0
        post.add_smirk
      else
        post.remove_smirk
      end
    end

    render json: {status: :created, message: 'Post commented', post:post}, status: :created
  end

  private
  def make_post_params
    params.require(:post).permit(:url_key, :user_id_array)
  end

  def fetch_posts_params
    params.require(:post).permit(:min_id)
  end

  def fetch_posts_for_user_params
    params.require(:user_id)
  end

  def like_post_params
    params.require(:post).permit(:post_id)
  end

  def comment_post_params
    params.require(:post).permit(:post_id, :type, :increment)
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
