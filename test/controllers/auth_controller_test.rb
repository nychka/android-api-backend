require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  def setup
    DatabaseCleaner.start
    @data = { success: true, body: attributes_for(:user) }
    @provider =  'facebook'
    @auth_token = 'CAAWmkXKqZBXsBAM41kULVjJ4nSYiYRgNo8AW8tfc0jRFPabQMcarHXpd4dciNPIioovqCO8ehb6hXq7besxPqTSGIUdOWmVeKG9JtMSdRRXbJZA4qLhJsTfgWQl5V1NqDCfNgDUkWgVlpL5BL1gF1TXK50qmgUL5r1EOPwwP9XCDK0QZCco'
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
    Facebook.any_instance.stubs(:get_user_info).returns(@data)
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
    @data[:body] = attributes_for(:social_user, age: nil)
    Facebook.any_instance.stubs(:get_user_info).returns(@data)
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal 102, body[:code], "require additional information to complete registration" 
    assert_equal @data[:body], body[:data][:user]
    assert_equal "can't be blank", body[:data][:errors][:age].join
  end
  test "user registers by social network two step procedure" do
    @data[:body] = attributes_for(:social_user, age: nil)
    Facebook.any_instance.stubs(:get_user_info).returns(@data)
    # First step
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal 102, body[:code], "require additional information to complete registration" 
    assert_equal @data[:body], body[:data][:user]
    assert_equal "can't be blank", body[:data][:errors][:age].join
    # Second step
    @data[:body][:age] = 22
    get :create, { provider: @provider, auth_token: @auth_token, user: @data[:body] }
    assert_response 201
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 201, body[:status]
    assert_equal 101, body[:code], "successfully registered"
    assert_equal 22, body[:data][:user][:age]
  end
  test "user registers by Facebook two step procedure" do
    #@data[:body] = { first_name: 'Yaroslav', last_name: 'Nychka' }
    #Facebook.any_instance.stubs(:get_user_info).returns(@data)
    user_fields = 'first_name,last_name,email'
    Facebook.any_instance.stubs(:user_fields).returns(user_fields)
    # First step
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    user = body[:data][:user]
    assert_equal 200, body[:status]
    assert_equal 102, body[:code], "require additional information to complete registration" 
    assert_equal "can't be blank", body[:data][:errors][:age].join
    # Second step
    user[:age] = 21
    get :create, { provider: @provider, auth_token: @auth_token, user: user }
    assert_response 201
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 201, body[:status]
    assert_equal 101, body[:code], "successfully registered"
    assert_equal 'Yaroslav', body[:data][:user][:first_name]
    assert_equal 'Nychka', body[:data][:user][:last_name]
    assert_equal 'nychka08@yandex.ru', body[:data][:user][:email]
    assert_equal 21, body[:data][:user][:age]
    assert_not_nil body[:data][:user][:access_token]
  end
  test "user registers by Vkontakte using uid" do
    get :index, { provider: 'vkontakte', auth_token: Settings.vkontakte.access_token, uid: Settings.vkontakte.uid }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal 102, body[:code]
    assert_equal 'Володимир', body[:data][:user][:first_name]
    assert_equal 'Ходонович', body[:data][:user][:last_name]
    assert_equal "can't be blank", body[:data][:errors][:age].join
    assert_equal "can't be blank", body[:data][:errors][:email].join
  end
end