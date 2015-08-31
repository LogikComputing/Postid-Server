class Api::V1::UserController < Api::V1::ApiController

  def login_or_register_user
    login_params

    request_username = params[:user][:username]
    user = User.find_by(username: request_username)

    if !user.present?
      username = params[:user][:username]
      fail NotAuthenticatedError.new(3) if username == 'nil'
      user = User.create(login_params)

      if !user.save
        render json: {error: 'Unable to save new user', messages: @user.errors.full_messages, status: :precondition_failed},
               status: :precondition_failed and return
      end
    else
      pass = params[:user][:password]
      fail NotAuthenticatedError.new(5) unless user.password == pass
    end

    user.add_checkin
    user.update_ip(request)

    render json: {status: :ok, message: 'login success', user: user}, status: :ok
  end

  def login_with_token
    params.require(:user).permit(:token)
    token = params[:user][:token]

    user = User.where(token: token).first
    fail NotAuthenticatedError.new(11) unless user.present?

    user.add_checkin
    user.update_ip(request)

    render json: {status: :ok, message: 'token login success', user: user}, status: :ok
  end

  def update_phone_number
    authenticate_request
    update_phone_number_params

    @user.update_attributes(phone_number: params[:user][:phone_number])
    @user.update_ip(request)

    render json: {status: :ok, message: 'Update phone success', user: @user}, status: :created

  end

  private
  def login_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :username)
  end

  def update_phone_number_params
    params.require(:user).permit(:token, :phone_number)
  end

end