require 'test_helper'

class VkontakteTest < ActiveSupport::TestCase
  def setup
    @provider = Vkontakte.new(Settings.vkontakte.access_token, uid: Settings.vkontakte.uid)
    @photo_url = 'http://cs614819.vk.me/v614819121/21800/ppOMqU_-ekg.jpg'
  end
  test "#get_data" do
    response = @provider.get_data('/method/getProfiles', uid: Settings.vkontakte.uid)
    assert response[:success]
    assert_equal 'Володимир', response[:body][:response][0][:first_name]
    assert_equal 'Ходонович',   response[:body][:response][0][:last_name]
  end
  test "method /users.get" do
    fields = 'sex,city,photo_200_orig,domain,bdate'
    response = @provider.get_data('/method/users.get', fields: fields, uid: Settings.vkontakte.uid)
    assert response[:success]
    assert_equal 'Володимир', response[:body][:response][0][:first_name]
    assert_equal 'Ходонович',   response[:body][:response][0][:last_name]
    assert_equal 2,   response[:body][:response][0][:sex]
    assert_equal "vovan4uck", response[:body][:response][0][:domain]
    assert_equal @photo_url, response[:body][:response][0][:photo_200_orig]
    assert_equal 4103, response[:body][:response][0][:city]
    assert_nil  response[:body][:bdate]
  end
  test "#get_user_info" do
    response = @provider.get_user_info
    assert response[:success]
    assert_equal 'Володимир', response[:body][:first_name]
    assert_equal 'Ходонович', response[:body][:last_name]
    assert_equal 2, response[:body][:gender]
    assert_equal "https://vk.com/vovan4uck", response[:body][:url]
    assert_equal @photo_url, response[:body][:photo]
    assert_equal 'Яворов', response[:body][:city]
  end
  test "bdate without year DD-MM" do
    data = { bdate: '17-02', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info

    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_nil response[:body][:bdate]
  end
  test "bdate with zero year DD-MM-YYYY" do
    data = { bdate: '17-02-0000', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info
    
    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_nil response[:body][:bdate]
  end
  test "bdate with defined year in format DD-MM-YYYY" do
    data = { bdate: '17-02-1989', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info
    
    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_equal '1989-02-17', response[:body][:bdate]
  end
  test "bdate with defined year in format YYYY-MM-DD" do
    data = { bdate: '1989-02-17', first_name: 'Woolf' }
    response_obj = OAuth2::Response.new({})
    response_obj.stubs(:body).returns(data.to_json)
    OAuth2::AccessToken.any_instance.stubs(:get).returns(response_obj)
    response = @provider.get_user_info
    
    assert response[:success]
    assert_equal 'Woolf', response[:body][:first_name]
    assert_equal '1989-02-17', response[:body][:bdate]
  end
end