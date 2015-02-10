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
    fields = 'sex'
    response = @provider.get_data('/method/users.get', fields: fields, uid: Settings.vkontakte.uid)
    assert response[:success]
    assert_equal 'Володимир', response[:body][:response][0][:first_name]
    assert_equal 'Ходонович',   response[:body][:response][0][:last_name]
    assert_equal 2,   response[:body][:response][0][:sex]
  end
  test "#get_user_info" do
    response = @provider.get_user_info
    assert response[:success]
    assert_equal 'Володимир', response[:body][:first_name]
    assert_equal 'Ходонович', response[:body][:last_name]
    assert_equal 'male', response[:body][:gender]
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