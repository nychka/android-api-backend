require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  setup do
    @error_msg = 'Access denied: access_token is empty or invalid'
  end
  test "access denied for unauthorized user" do
    get :index, {}
    body = JSON.parse(response.body).symbolize_keys
    assert_response 403
    assert_equal 403, body[:status]
    assert_equal @error_msg, body[:error_msg]
  end
  test "access denied for invalid access token" do
    user = create(:user)
    access_token = "#{user.access_token}i"
    get :index, { access_token: access_token }
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_response 403
    assert_equal 403, body[:status]
    assert_equal @error_msg, body[:error_msg]
  end
  test "access allowed for authorized user" do
    user = create(:user)
    get :index, { access_token: user.access_token }
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_response 200
    assert_equal 200, body[:status]
    assert_equal user.first_name, body[:data][:user][:first_name]
  end
end