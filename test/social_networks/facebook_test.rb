require 'test_helper'

class FacebookTest < ActiveSupport::TestCase
	def setup
		@provider = Facebook.new(Settings.facebook.access_token)
	end
	test "#get_data" do
		response = @provider.get_data('/me', { fields: 'first_name, last_name, gender, email, age_range, location, link, picture' })
		assert response[:success]
		assert_equal 'Yaroslav', response[:body][:first_name]
		assert_equal 'Nychka', 	 response[:body][:last_name]
		assert_equal 21, response[:body][:age_range][:min]
		assert_equal 'male', 	 response[:body][:gender]
		assert_equal 'nychka08@yandex.ru', 	 response[:body][:email]
		assert_equal 'Lviv, Ukraine', response[:body][:location][:name]
		assert_equal 'https://www.facebook.com/app_scoped_user_id/876897375710693/', response[:body][:link]
		assert_equal response[:body][:picture][:data][:url], 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xaf1/v/t1.0-1/p50x50/10933767_867907716609659_5536678363741348646_n.jpg?oh=87804d407bef55bd79966b91238c866e&oe=55557B02&__gda__=1431262901_46d987031814e00d4bc22b65cf2451fe'
	end
	test "#get_user_info" do
		response = @provider.get_user_info
		assert response[:success]
		assert_equal 'Yaroslav', response[:body][:first_name]
		assert_equal 'Nychka', 	 response[:body][:last_name]
		assert_equal 21, response[:body][:age]
		assert_equal 'nychka08@yandex.ru', response[:body][:email]
		assert_equal 2, 	 response[:body][:gender]
		assert_equal 'Lviv', response[:body][:city]
		assert_equal 'https://www.facebook.com/app_scoped_user_id/876897375710693/', response[:body][:url]
		assert_equal response[:body][:photo], 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xaf1/v/t1.0-1/p50x50/10933767_867907716609659_5536678363741348646_n.jpg?oh=87804d407bef55bd79966b91238c866e&oe=55557B02&__gda__=1431262901_46d987031814e00d4bc22b65cf2451fe'
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