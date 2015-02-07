require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  def setup
    DatabaseCleaner.start
    @user_data = attributes_for(:user)
    @provider, @auth_token = 'facebook', 'CAAWmkXKqZBXsBAD4xxQBjnkpWj9Fj4ZBqsPah3rEBUbkznUfJ42aFU58jA9m8xL1zJ4fEs6WqNbfWXKEJSAszG0IpbwW3Y9evVee7oRSJkZCTe8GJvkxDMpSJNw4DEEnCFPX7ikqxqk7sbmqXFE9B6wwccIJqQx8zDHovCnny0sR6OCbB2SyKt5pN0BqiGlxrDz9fb10pG6vsQSoPbpd7soyEpzGAwZD'
  end
  def teardown
    DatabaseCleaner.clean
  end
  test "user successfully authorizes by social network" do
    user = create(:user)
    auth = create(:authentication, user_id: user.id)
    @controller.stubs(:define_social_provider)
    get :index, { provider: auth.provider, auth_token: auth.auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal 100, body[:code], "successfully authorized"
    created_user = user.attributes.symbolize_keys.delete_if{ |k,v| k =~ /_at$/ }
    received_user = body[:data][:user].delete_if{ |k,v| k =~ /_at$/ }
    assert_equal created_user, received_user
  end
  test "social network is unsupported" do
    get :index, { provider: 'twitter', auth_token: @auth_token }
    assert_response 422
    body = JSON.parse(response.body).symbolize_keys
    assert_equal 422, body[:status]
    assert_equal 500, body[:code]
  end
  test "user successfully registers by social network" do
    Facebook.any_instance.stubs(:get_user_info).returns(@user_data)
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 201
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 201, body[:status]
    assert_equal 101, body[:code], "successfully registered"
    authentication = Authentication.find_by(user_id: body[:data][:user][:id])
    assert_equal @provider, authentication.provider
    assert_equal @auth_token, authentication.auth_token
  end
  test "user registers by social network two step procedure: 1 / 2" do
    user_data = attributes_for(:social_user, age: nil)
    Facebook.any_instance.stubs(:get_user_info).returns(user_data)
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal 102, body[:code], "require additional information to complete registration" 
    assert_equal user_data, body[:data][:user]
    assert_equal "can't be blank", body[:data][:errors][:age].join
  end
  test "user registers by social network two step procedure" do
    user_data = attributes_for(:social_user, age: nil)
    Facebook.any_instance.stubs(:get_user_info).returns(user_data)
    # First step
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal 102, body[:code], "require additional information to complete registration" 
    assert_equal user_data, body[:data][:user]
    assert_equal "can't be blank", body[:data][:errors][:age].join
    # Second step
    user_data[:age] = 22
    get :create, { provider: @provider, auth_token: @auth_token, user: user_data }
    assert_response 201
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 201, body[:status]
    assert_equal 101, body[:code], "successfully registered"
    assert_equal 22, body[:data][:user][:age]
  end
  test "user registers by Facebook two step procedure" do
    #user_data = { first_name: 'Yaroslav', last_name: 'Nychka' }
    #Facebook.any_instance.stubs(:get_user_info).returns(user_data)
    # First step
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    user_data = body[:data][:user]
    assert_equal 200, body[:status]
    assert_equal 102, body[:code], "require additional information to complete registration" 
    assert_equal "can't be blank", body[:data][:errors][:age].join
    assert_equal "can't be blank", body[:data][:errors][:email].join
    # Second step
    user_data[:age] = 22
    user_data[:email] = 'nychka93@gmail.com'
    get :create, { provider: @provider, auth_token: @auth_token, user: user_data }
    assert_response 201
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 201, body[:status]
    assert_equal 101, body[:code], "successfully registered"
    assert_equal 'Yaroslav', body[:data][:user][:first_name]
    assert_equal 'Nychka', body[:data][:user][:last_name]
    assert_not_nil body[:data][:user][:access_token]
  end
end