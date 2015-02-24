class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  def authorize!(settings=nil)
    default_settings = { access_token: params[:access_token] }
    options = ( settings.nil? ) ? default_settings : settings
    if user = User.find_by(options)
      @current_user = user
    else
      message = "#{request.remote_ip} is trying to authorize "
      message += (params[:access_token] and not params[:access_token].empty?) ? "with invalid access_token #{params[:access_token]}" : "without access_token"
      logger.error("ProfileController#authorize!") { message }
      render json: { status: 401, error_msg: 'Access denied: access_token is empty or invalid' }, status: 401
    end
  end
end
