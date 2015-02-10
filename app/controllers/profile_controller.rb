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
      render json: { status: 403, error_msg: 'Access denied: access_token is empty or invalid' }, status: 403
    end
  end
end