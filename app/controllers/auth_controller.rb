class AuthController < ApplicationController
	def create
		provider, auth_token = params[:provider], params[:auth_token]
		data = get_data(provider, auth_token)
		user = User.new data
		if user.save 
			user.authentications.find_or_create_by(provider: provider, auth_token: auth_token)
			render json: { status: :created, data: { user: user }, code: 102 }, status: :created
		else
			render json: { status: 422, data: { user: data, errors: user.errors}, status: :unprocessable_entity }
		end
	end

	private

	def get_data(provider, auth_token)
		# call to facebook and receiving data
		{ first_name: 'Jack', last_name: 'Sparrow', photo: "http://robohash.org/my-own-slug.png?size=300x300" }
	end
end
