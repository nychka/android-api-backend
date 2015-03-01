require 'test_helper'

class FacebookTest < ActiveSupport::TestCase
	def setup
		@provider = Facebook.new(Settings.facebook.access_token)
    @default_picture_size = 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xaf1/v/t1.0-1/c0.0.50.50/p50x50/10991287_883609968372767_4105506535833576513_n.jpg?oh=c1c2eaaf485b36e866e540f0ddb2c0d4&oe=55902C34&__gda__=1434609255_26a62f4ec188fc10ec85f245652de6e5'
    @photo_url = 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xaf1/v/t1.0-1/c0.0.200.200/p200x200/10991287_883609968372767_4105506535833576513_n.jpg?oh=f2d0569d4b1d013275abd1cb3b0e951f&oe=55861939&__gda__=1433917562_60980af084ea469de71c209807e1e960'
	end
	test "#get_data" do
		response = @provider.get_data('/me', { fields: 'first_name, last_name, gender, email, age_range, location, link, picture, birthday' })
		assert response[:success]
		assert_equal 'Yaroslav', response[:body][:first_name]
		assert_equal 'Nychka', 	 response[:body][:last_name]
		assert_equal 21, response[:body][:age_range][:min]
		assert_equal 'male', 	 response[:body][:gender]
		assert_equal 'nychka08@yandex.ru', 	 response[:body][:email]
		assert_equal 'Lviv, Ukraine', response[:body][:location][:name]
		assert_equal 'https://www.facebook.com/app_scoped_user_id/876897375710693/', response[:body][:link]
		assert_equal response[:body][:picture][:data][:url], @default_picture_size
		assert_equal '02/17/1993', response[:body][:birthday]
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
		assert_equal response[:body][:photo], @photo_url
		assert_equal '1993-02-17', response[:body][:bdate]
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
	test "birthday without year DD-MM" do
    data = { birthday: '17/02', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info

    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_nil response[:body][:birthday]
  end
  test "birthday with zero year MM-DD-YYYY" do
    data = { birthday: '02/17/0000', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info
    
    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_nil response[:body][:bdate]
    assert_nil response[:body][:birthday]
  end
  test "birthday with defined year in format MM-DD-YYYY" do
    data = { birthday: '02/17/1989', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info
    
    assert response[:success]
    assert_nil response[:body][:birthday]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_equal '1989-02-17', response[:body][:bdate]
  end
  test "get user picture 200x200" do
    response = @provider.get_data('/me/picture', { height: 200, width: 200, redirect: false } ) # 200x200
    assert response[:success]
    assert_match /200x200/, response[:body][:data][:url]
  end
end