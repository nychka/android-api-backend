class ProfileController < ApplicationController
  before_action :authorize!

  def index
    render json: { status: 200, data: { user: @current_user }}, status: :ok
  end

  private
  def authorize!
    if user = User.find_by(access_token: params[:access_token])
      @current_user = user
    else
      message = "#{request.remote_ip} is trying to authorize "
      message += (params[:access_token] and not params[:access_token].empty?) ? "with invalid access_token #{params[:access_token]}" : "without access_token"
      logger.error("ProfileController#authorize!") { message }
      render json: { status: 401, error_msg: 'Access denied: access_token is empty or invalid' }, status: 401
    end
  end
end