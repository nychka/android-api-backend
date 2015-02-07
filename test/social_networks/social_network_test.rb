require 'test_helper'

class SocialNetworkTest < ActiveSupport::TestCase
	def setup
		@auth_token = 'XYZ'
		@social_network = SocialNetwork.new
	end
	test "#auth_token" do
		@social_network.auth_token = @auth_token
		assert_respond_to @social_network, :auth_token
		assert_equal @auth_token, @social_network.auth_token
	end
	test "#get_user_info" do
		appID = '1590518507829627'
		appSecret = 'b6365344cb03d318431411494b68a699'
		accessToken = 'CAAWmkXKqZBXsBAD4xxQBjnkpWj9Fj4ZBqsPah3rEBUbkznUfJ42aFU58jA9m8xL1zJ4fEs6WqNbfWXKEJSAszG0IpbwW3Y9evVee7oRSJkZCTe8GJvkxDMpSJNw4DEEnCFPX7ikqxqk7sbmqXFE9B6wwccIJqQx8zDHovCnny0sR6OCbB2SyKt5pN0BqiGlxrDz9fb10pG6vsQSoPbpd7soyEpzGAwZD'
		client = OAuth2::Client.new(appID, appSecret, site: 'https://graph.facebook.com')
		token = OAuth2::AccessToken.new(client, accessToken)
		response = token.get('/me', params: { fields: 'first_name, last_name, email' })
		assert_equal 200, response.status
		body = JSON.parse(response.body).symbolize_keys
		assert_equal "Yaroslav", body[:first_name]
		assert_equal "Nychka", 	body[:last_name]
	end
end