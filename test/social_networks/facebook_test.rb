require 'test_helper'

class FacebookTest < ActiveSupport::TestCase
	def setup
		@provider = Facebook.new(Settings.facebook.access_token)
	end
	test "#get_data" do
		response = @provider.get_data('/me', { fields: 'first_name, last_name' })
		assert response[:success]
		assert 'Yaroslav', response[:body][:first_name]
		assert 'Nychka', 	 response[:body][:last_name]
		assert_nil response[:body][:age]
	end
	test "#get_data with invalid token" do
		provider = Facebook.new('XYZ')
		response = provider.get_data('/me', { fields: 'first_name, last_name' })
		refute response[:success]
		assert_match /Invalid OAuth access token/, response[:error]
	end
	test "#get_data with invalid field" do
		response = @provider.get_data('/me', { fields: 'first_name, last_name, foo' })
		refute response[:success]
		assert_match /Tried accessing nonexisting field \(foo\)/, response[:error]
	end
end