class UsersController < ApiController
  before_action :authorize!, only: [:show, :nearby]
  before_action :authorize_with_settings, only: :update
  before_action :set_user, only: :show
  before_action :refresh_location, only: :nearby
  before_action :generate_ads, only: [:show, :nearby]

  def show
    if @user
      render '/users/show', locals: { status: 200, user: @user, ads: @ads }, status: :ok
    else
      render json: { status: 404, error_msg: 'user not found'}, status: :not_found
    end
  end
  def create
    if user = User.find_by(email: user_params[:email])
      user.add_social_network authentication_params
      render '/users/create', locals: { status: 200, user: @user }, status: :ok and return
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
      render '/users/create', locals: { status: 200, user: @current_user }, status: :ok
    else
      render json: { status: 422, data: { user: user_params, errors: @current_user.errors.messages }, code: 104 }, status: :unprocessable_entity
    end
  end

  def nearby
    if @current_user.geocoded?
      users = User.nearby(@current_user)
      render '/users/nearby', locals: { status: 200, users: users, ads: @ads }, status: :ok
    else
      render json: { status: 405, error_msg: 'user must provide current coordinates: latitude and longitude' }, status: :method_not_allowed
    end
  end

  private
  def generate_ads
    @ads = AdGenerator.generate(current_user: @current_user)
  end
  def authorize_with_settings
    settings = {}
    if params[:user] && params[:user][:access_token]
      settings[:access_token] = params[:user][:access_token]
    end
    authorize! settings
  end
  def set_user
    @user = User.find(params[:id]) rescue nil
  end
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :age, :gender, :city, :photo, :bdate, :longitude, :latitude, :phone, :links => [])
  end
  def authentication_params
    { provider: params[:provider], auth_token: params[:auth_token] }
  end
end
