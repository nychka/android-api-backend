require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  def setup
    DatabaseCleaner.start
    @data = { success: true, body: attributes_for(:user) }
    @provider =  'facebook'
    @auth_token = Settings[@provider]['access_token']
    @request.headers["Content-Type"] = "application/json"
    @request.headers["Accept"] = "application/json"
  end
  def teardown
    DatabaseCleaner.clean
  end
  test "creates user without unnecessary fields" do
    @data[:body][:gender] = nil
    @data[:body][:city] = nil
    @data[:body][:age] = nil
    @data[:body][:links] = nil
    Facebook.any_instance.stubs(:get_user_info).returns(@data)
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 201
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 201, body[:status]
    assert_nil body[:data][:errors]
  end
  test "bad request format" do
    @request.headers["Accept"] = "application/html"
    @request.headers['Content-Type'] = 'application/html'
    user = create(:user)
    auth = create(:authentication, user_id: user.id)
    get :index, { provider: auth.provider, auth_token: auth.auth_token }
    assert_response 400
    body = JSON.parse(response.body).symbolize_keys
    assert_equal 400, body[:status]
    assert_match /Bad request/, body[:error_msg]
  end
  test "user successfully authorizes by social network" do
    user = create(:user)
    auth = create(:authentication, user_id: user.id)
    @controller.stubs(:define_social_provider)
    get :index, { provider: auth.provider, auth_token: auth.auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    user_as_json = Rabl.render(user, 'users/user', view_path: 'app/views', format: :hash)
    received_user = body[:data][:user]
    assert_equal 200, body[:status]
    #assert_equal 100, body[:code], "successfully authorized"
    assert_equal user_as_json, received_user
  end
  test "social network is unsupported" do
    get :index, { provider: 'twitter', auth_token: @auth_token }
    assert_response 422
    body = JSON.parse(response.body).symbolize_keys
    assert_equal 422, body[:status]
    #assert_equal 500, body[:code]
  end
  test "user successfully registers by social network" do
    Facebook.any_instance.stubs(:get_user_info).returns(@data)
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 201
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 201, body[:status]
    #assert_equal 101, body[:code], "successfully registered"
    authentication = Authentication.find_by(user_id: body[:data][:user][:id])
    assert_equal @provider, authentication.provider
    assert_equal @auth_token, authentication.auth_token
  end
  test "user registers by social network two step procedure: 1 / 2" do
    extra = { bdate: nil, links: Array(Settings[@provider]['site']) }
    @data[:body] = attributes_for(:social_user, email: nil, url: Settings[@provider]['site']).merge(extra)
    Facebook.any_instance.stubs(:get_user_info).returns(@data)
    get :index, { provider: @provider, auth_token: @auth_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    #assert_equal 102, body[:code], "require additional information to complete registration" 
    @data[:body].delete(:url)
    assert_equal @data[:body], body[:data][:user]
    assert_equal "can't be blank", body[:data][:errors][:email].join
    assert_equal 1, body[:data][:user][:links].count
    assert_equal Settings[@provider]['site'], body[:data][:user][:links].first
  end
  test "user registers by Vkontakte using uid" do
    get :index, { provider: 'vkontakte', auth_token: Settings.vkontakte.access_token, uid: Settings.vkontakte.uid }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    #assert_equal 102, body[:code]
    assert_equal 'Володимир', body[:data][:user][:first_name]
    assert_equal 'Ходонович', body[:data][:user][:last_name]
    assert_equal "can't be blank", body[:data][:errors][:email].join
  end
  test "user adds other social network" do
    email = 'test@mail.com'
    user = create(:user, email: email)
    @data[:body] = attributes_for(:social_user, email: email, url: Settings['gplus']['site'])
    Gplus.any_instance.stubs(:get_user_info).returns(@data)
    # 1. add one social network to existing user
    user.authentications << build(:authentication, provider: 'facebook')
    # 2. register using Gplus with the same email
    get :index, { provider: 'gplus', auth_token: Settings.gplus.access_token }
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    # 3. Gplus must connect to existing user
    #assert_equal 103, body[:code], "social network has been connected to user"
    assert_equal 2, user.authentications.count
  end
  test "user connects Gplus and Facebook" do
    email = 'test@mail.com'
    user = create(:user, email: email)
    user.authentications << build(:authentication, provider: 'vkontakte')
    # mocking data
    @data[:body] = attributes_for(:social_user, email: email, url: Settings['gplus']['site'])
    Gplus.any_instance.stubs(:get_user_info).returns(@data)
    @data[:body] = attributes_for(:social_user, email: email, url: Settings['facebook']['site'])
    Facebook.any_instance.stubs(:get_user_info).returns(@data)
    # 2. register using Gplus with the same email
    get :index, { provider: 'gplus', auth_token: Settings.gplus.access_token }
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    # 3. Gplus must connect to existing user
    #assert_equal 103, body[:code], "social network has been connected to user"
    assert_equal 2, user.authentications.count
    # 4. register using Facebook with the same email
    get :index, { provider: 'facebook', auth_token: Settings.facebook.access_token }
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    # 5. Facebook must connect to existing user
    #assert_equal 103, body[:code], "social network has been connected to user"
    assert_equal 3, user.authentications.count
  end
end