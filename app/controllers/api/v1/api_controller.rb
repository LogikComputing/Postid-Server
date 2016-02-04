class Api::V1::ApiController < ActionController::Base
  include NotificationHelper

  respond_to :json
  before_filter :setup_globals

  def index
    respond_to do |format|
      format.json { render json: {api_ver: @api_version, status: :ok}, status: :ok }
      format.html { render html: "<h2>Go@It API Version #{@api_version}</h2>".html_safe, status: :ok }
    end
  end

  def authenticate_request(api_token = request.headers['token'])
    fail NotAuthenticatedError.new(3) unless api_token.present?

    api_token = api_token.split(' ').last

    @user = User.where(token: api_token).first
    fail NotAuthenticatedError.new(11) unless @user.present?

    return true
  end

  class NotAuthenticatedError < StandardError
    def initialize(error_code)
      @error_code = "Code: #{error_code}"
    end

    def error_code
      @error_code
    end
  end

  class UnavailableError < StandardError
    def initialize(error_code)
      @error_code = "Code: #{error_code}"
    end

    def error_code
      @error_code
    end
  end

  rescue_from NotAuthenticatedError do |error|
    respond_to do |format|
      format.json { render json: {message: 'Not Authorized', error_code: error.error_code, status: :unauthorized}, status: :unauthorized }
      format.html { render html: "<h2>Unauthorized API Access (Error #{error.error_code})</h2>".html_safe, status: :unauthorized }
    end
  end

  rescue_from UnavailableError do |error|
    respond_to do |format|
      format.json { render json: {message: 'Unavailable', error_code: error.error_code, status: :unauthorized}, status: :unauthorized }
      format.html { render html: "<h2>Unavailable API Access (Error #{error.error_code})</h2>".html_safe, status: :unauthorized }
    end
  end

  private
  def setup_globals
    @api_version = 1
  end

end