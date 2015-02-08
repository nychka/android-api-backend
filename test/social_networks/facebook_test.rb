require 'test_helper'

class FacebookTest < ActiveSupport::TestCase
	def setup
		@access_token = 'CAAWmkXKqZBXsBAD4xxQBjnkpWj9Fj4ZBqsPah3rEBUbkznUfJ42aFU58jA9m8xL1zJ4fEs6WqNbfWXKEJSAszG0IpbwW3Y9evVee7oRSJkZCTe8GJvkxDMpSJNw4DEEnCFPX7ikqxqk7sbmqXFE9B6wwccIJqQx8zDHovCnny0sR6OCbB2SyKt5pN0BqiGlxrDz9fb10pG6vsQSoPbpd7soyEpzGAwZD'
		@social_network = Facebook.new(@access_token)
	end
	test "#access_token" do
		@social_network.access_token = @access_token
		assert_respond_to @social_network, :access_token
		assert_equal @access_token, @social_network.access_token
	end
end