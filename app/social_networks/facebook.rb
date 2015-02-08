class Facebook < SocialNetwork
	attr_accessor :access_token, :user_fields

	def initialize(access_token)
		appID = '1590518507829627'
		appSecret = 'b6365344cb03d318431411494b68a699'
		@client = OAuth2::Client.new(appID, appSecret, site: 'https://graph.facebook.com')
		@endpoint = OAuth2::AccessToken.new(@client, access_token)
		@user_fields = 'first_name, last_name, email, age_range'
	end
	def get_user_info
		get_data('/me',  { fields: user_fields }) do |body|
			if body.has_key? :age_range and body[:age_range].has_key? :min
				body[:age] = body[:age_range][:min]
				body.delete(:age_range)
			end
			body
		end
	end
	def get_data(path, params)
		begin
			result = { success: true }
			response = @endpoint.get(path, params: params)
			result[:body] = JSON.parse(response.body).deep_symbolize_keys
			result[:body] = yield(result[:body]) if block_given?
		rescue Exception => e
			result[:success] = false
			result[:error] = e.message
		ensure
			return result
		end
	end
end