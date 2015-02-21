class ProfileController < ApplicationController
  before_action :authorize!

  def index
    render json: { status: 200, data: { user: @current_user }}, status: :ok
  end
end