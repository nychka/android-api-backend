class Facebook < SocialNetwork
	attr_accessor :access_token

	def initialize(access_token)
		appID = '1590518507829627'
		appSecret = 'b6365344cb03d318431411494b68a699'
		@client = OAuth2::Client.new(appID, appSecret, site: 'https://graph.facebook.com')
		@endpoint = OAuth2::AccessToken.new(@client, access_token)
	end
	def get_user_info
		response = @endpoint.get('/me', params: { fields: 'first_name, last_name, email' })
		JSON.parse(response.body).deep_symbolize_keys
	end
end