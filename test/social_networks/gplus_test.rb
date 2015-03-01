require 'test_helper'

class GplusTest < ActiveSupport::TestCase
  def setup
   # each test
    @provider = Gplus.new(Settings.gplus.access_token)
    @provider.refresh_token!
    @url = '/plus/v1/people/me'
    @default_photo = 'https://lh6.googleusercontent.com/-EOoHdnqhmaU/AAAAAAAAAAI/AAAAAAAAEQs/FPhz4bEwXVs/photo.jpg?sz=50'
    @photo = 'https://lh6.googleusercontent.com/-EOoHdnqhmaU/AAAAAAAAAAI/AAAAAAAAEQs/FPhz4bEwXVs/photo.jpg?sz=200'
  end
  test "#get_data" do
    response = @provider.get_data(@url, { fields: 'gender,ageRange,birthday,emails, name(familyName,givenName),url, image(url), placesLived' })
    assert response[:success]
    assert_equal 'male', response[:body][:gender]
    assert_equal 'nychka93@gmail.com',   response[:body][:emails][0][:value]
    assert_equal 'Ярослав', response[:body][:name][:givenName]
    assert_equal 'Ничка', response[:body][:name][:familyName]
    assert_equal response[:body][:url], 'https://plus.google.com/+ЯрославНичка'
    assert_equal @default_photo, response[:body][:image][:url]
    assert_equal 21, response[:body][:ageRange][:min]
    assert_equal 'Lviv', response[:body][:placesLived][0][:value]
    assert_equal '1986-04-26', response[:body][:birthday]
  end
  test "#get_data with invalid token" do
    provider = Gplus.new('invalid_token')
    response = provider.get_data(@url, { fields: 'gender' })
    refute response[:success]
    assert_match /Invalid Credentials/, response[:error]
  end
  test "#get_data with invalid field" do
    response = @provider.get_data(@url, { fields: 'gender,ageRange,emails,familyName' })
    refute response[:success]
    assert_match /Invalid field selection familyName/, response[:error]
  end
  test "#get_user_info" do
    response = @provider.get_user_info
    assert response[:success]
    assert_equal 2, response[:body][:gender]
    assert_equal 'nychka93@gmail.com',   response[:body][:email]
    assert_equal 'Ярослав', response[:body][:first_name]
    assert_equal 'Ничка', response[:body][:last_name]
    assert_equal 21, response[:body][:age]
    assert_equal @photo, response[:body][:photo]
    assert_equal 'https://plus.google.com/+ЯрославНичка', response[:body][:url]
    assert_equal 'Lviv', response[:body][:city]
    assert_equal '1986-04-26', response[:body][:bdate]
  end
  test "refresh token" do
    provider = Gplus.new('invalid_token')
    response = provider.get_user_info
    refute response[:success]
    assert_match /Invalid Credentials/, response[:error]
    provider.refresh_token!
    response = provider.get_user_info
    assert_equal 2, response[:body][:gender]
    assert_equal 'nychka93@gmail.com',   response[:body][:email]
    assert_equal 'Ярослав', response[:body][:first_name]
    assert_equal 'Ничка', response[:body][:last_name]
    assert_equal 21, response[:body][:age]
  end
  test "bdate without year DD-MM" do
    data = { birthday: '17-02', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info

    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_nil response[:body][:bdate]
  end
  test "bdate with zero year DD-MM-YYYY" do
    data = { birthday: '17-02-0000', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info
    
    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_nil response[:body][:bdate]
  end
  test "bdate with defined year in format DD-MM-YYYY" do
    data = { birthday: '17-02-1989', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info
    
    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_equal '1989-02-17', response[:body][:bdate]
  end
  test "bdate with defined year in format YYYY-MM-DD" do
    data = { birthday: '1989-02-17', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info
    
    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_equal '1989-02-17', response[:body][:bdate]
  end
end