class ApiController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_user
  before_filter :check_request_format

  def authorize!(settings=nil)
    default_settings = { access_token: params[:access_token] }
    options = ( settings.nil? || settings.empty? ) ? default_settings : settings
    if user = User.find_by(options)
      @current_user = user
      @current_user
    else
      message = "#{request.remote_ip} is trying to authorize "
      message += (params[:access_token] and not params[:access_token].empty?) ? "with invalid access_token #{params[:access_token]}" : "without access_token"
      logger.error("ProfileController#authorize!") { message }
      render json: { status: 401, error_msg: 'Access denied: access_token is empty or invalid' }, status: 401
    end
  end

  def check_request_format
    unless request.format == Mime::JSON
      render json: { status: 400, error_msg: 'Bad request. Please, make sure to add headers for your request: Content-Type: application/json and Accept: application/json' }, status: 400
    end
  end
  def refresh_location
    if params[:longitude] && params[:latitude]
      @current_user.update(latitude: params[:latitude], longitude: params[:longitude])
    end
  end

  private 

  def current_user
    @current_user
  end
end
