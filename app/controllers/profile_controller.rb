class ProfileController < ApplicationController
  before_action :authorize!

  def index
    #render json: { status: 200, data: { user: @current_user }}, status: :ok
    render '/users/create', locals: { status: 200, user: @current_user }, status: :ok
  end
end