class Admin::UsersController < ApplicationController
	before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.paginate(page: params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to [:admin, @user], notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    @user.update(user_params)
    redirect_to [:admin, @user], notice: 'User was successfully updated.'
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: 'User was successfully destroyed.'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :city, :gender, :age, :bdate, :links, :photo, :phone, :longitude, :latitude)
    end
end
