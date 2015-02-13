require 'test_helper'

class VkontakteTest < ActiveSupport::TestCase
  def setup
    @provider = Vkontakte.new(Settings.vkontakte.access_token, uid: Settings.vkontakte.uid)
  end
  test "#get_data" do
    response = @provider.get_data('/method/getProfiles', uid: Settings.vkontakte.uid)
    assert response[:success]
    assert_equal 'Володимир', response[:body][:response][0][:first_name]
    assert_equal 'Ходонович',   response[:body][:response][0][:last_name]
  end
  test "method /users.get" do
    fields = 'sex,city,photo_100,domain'
    response = @provider.get_data('/method/users.get', fields: fields, uid: Settings.vkontakte.uid)
    assert response[:success]
    assert_equal 'Володимир', response[:body][:response][0][:first_name]
    assert_equal 'Ходонович',   response[:body][:response][0][:last_name]
    assert_equal 2,   response[:body][:response][0][:sex]
    assert_equal "vovan4uck", response[:body][:response][0][:domain]
    assert_equal 'http://cs614819.vk.me/v614819121/21825/c4G3zwahwbw.jpg', response[:body][:response][0][:photo_100]
    assert_equal 4103, response[:body][:response][0][:city]
  end
  test "#get_user_info" do
    response = @provider.get_user_info
    assert response[:success]
    assert_equal 'Володимир', response[:body][:first_name]
    assert_equal 'Ходонович', response[:body][:last_name]
    assert_equal 2, response[:body][:gender]
    assert_equal "https://vk.com/vovan4uck", response[:body][:url]
    assert_equal 'http://cs614819.vk.me/v614819121/21825/c4G3zwahwbw.jpg', response[:body][:photo]
    assert_equal 'Lviv', response[:body][:city]
  end
  #http://vk.com/dev/secure.checkToken
  # test '/method/secure.checkToken' do
  #   response = @provider.get_data('/method/secure.checkToken', { 
  #     access_token: Settings.vkontakte.access_token,
  #     client_secret: Settings.vkontakte.app_secret
  #   })
  #   p response
  #   assert response[:success]
  #   assert_equal 1, response[:body][:success]
  #   assert_equal Settings.vkontakte.uid, response[:body][:user_id]
  # end
end