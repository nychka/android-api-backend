class UsersController < ApplicationController
  before_action :authorize!, except: :create

  def create
    if user = User.find_by(email: user_params[:email])
      user.add_social_network authentication_params
      render json: { status: 200, data: { user: user }, code: 103 }, status: :ok and return
    end
    user = User.new(user_params)
    if user.save
      user.add_social_network authentication_params
      render json: { status: 201, data: { user: user }, code: 101 }, status: :created
    else
      render json: { status: 422, data: { user: user_params, errors: user.errors.messages }, code: 104 }, status: :unprocessable_entity
    end
  end

  def update
    @current_user.attributes = user_params
    if @current_user.save
      render json: { status: 200, data: { user: @current_user.as_json }, code: 110 }, status: :ok
    else
      render json: { status: 422, data: { user: user_params, errors: @current_user.errors.messages }, code: 104 }, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :age, :gender, :city, :photo, :bdate)
    end
    def authentication_params
      { provider: params[:provider], auth_token: params[:auth_token] }
    end
end
