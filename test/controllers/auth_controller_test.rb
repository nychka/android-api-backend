require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  setup do
    @auth_token = Digest::SHA1.hexdigest Time.now.to_s
    @complete_user_data = attributes_for(:user)
    @incomplete_user_data = attributes_for(:user, email: nil)
    
  end
  test "incomplete registration part 1/2" do
    @controller.stubs(:get_data).returns(@incomplete_user_data)
    get :create, { provider: 'facebook', auth_token: @auth_token }
    # json response with user data
    assert_response 200, response.status
    body = JSON.parse(response.body, symbolize_keys: true)
    assert_equal 101, body[:code], "require additional information from user to complete registration"
    assert_equal body[:data][:user], @incomplete_user_data
    assert_includes "email", body[:data][:required_fields]
  end
  # test "incomplete registration part 2/2" do
  #   post :create, { provider: 'facebook', auth_token: @auth_token, user: @complete_user_data }
  #   # json response with user data
  #   assert_response 201, response.status
  #   body = JSON.parse(response.body, symbolize_keys: true)
  #   assert_equal 102, body[:code], "registration succeded"
  #   assert_equal body[:data][:user], User.last.as_json.symbolize_keys
  #   assert_includes "email", body[:data][:required_fields]
  # end
  # test "user finishes authorization by registration" do
  #   @controller.stubs(:get_data).returns(@complete_user_data)
  #   get :create, { provider: 'facebook', auth_token: @auth_token }
  #   assert_reponse 201, response.status
  #   body = JSON.parse(response.body, symbolize_keys: true)
  #   assert_equal 102, body[:code], "registration succeded"
  #   assert_equal body[:data][:user], User.last.as_json.symbolize_keys
  # end
end