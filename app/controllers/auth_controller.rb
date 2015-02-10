class AuthController < ApplicationController
	before_filter :define_social_provider

	def index
		if user = Authentication.find_by(provider: params[:provider], auth_token: params[:auth_token]).try(:user)
			render json: { status: 200, data: { user: user }, code: 100 }, status: :ok
		else
			response = @provider.get_user_info
			unless response[:success]
				render json: { status: 422, error_msg: response[:error] }, status: :unprocessable_entity and return
			end
			data = response[:body]
			user_params = { first_name: data[:first_name], last_name: data[:last_name], email: data[:email], age: data[:age] }
			user = User.new user_params
			if user.save
				user.authentications << Authentication.new(provider: params[:provider], auth_token: params[:auth_token])
				render json: { status: 201, data: { user: user }, code: 101 }, status: :created
			else
				render json: { status: 200, data: { user: user_params, errors: user.errors.messages }, code: 102 }, status: :ok
			end
		end
	end

	def create
		user = User.new(user_params)
		if user.save
			user.authentications << Authentication.new(provider: params[:provider], auth_token: params[:auth_token])
			render json: { status: 201, data: { user: user }, code: 101 }, status: :created
		else
			render json: { status: 422, data: { user: user_params, errors: user.errors.messages }, code: 104 }, status: :unprocessable_entity
		end
	end

	private

	def define_social_provider
		if Settings.social_networks.include? params[:provider]
			providerKlass = params[:provider].titleize.constantize
			@provider = providerKlass.new(params[:auth_token], white_params)
		else
			render json: { status: 422, error_msg: "Sorry, but this provider doesn't supported yet", code: 500 }, status: :unprocessable_entity
		end
	end
	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :age)
	end
	def white_params
		options = {}
		Settings.white_params.each do |item|
			param = item.to_sym
			options[param] = params[param] if params.has_key?(param) and not params[param].empty?
		end
		options
	end
end
