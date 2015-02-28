require 'test_helper'

class UserRegistrationFlowsTest < ActionDispatch::IntegrationTest
    def setup
    	DatabaseCleaner.start
    	@data = { success: true, body: attributes_for(:user) }
    	@provider = 'facebook'
    	@auth_token = Settings[@provider]['access_token']
        @headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    end
	def teardown
		DatabaseCleaner.clean
	end
	test "user registers by Facebook two step procedure" do
        user_fields = 'first_name,last_name,gender,location'
        Facebook.any_instance.stubs(:user_fields).returns(user_fields)
        # First step
        get '/auth', { provider: @provider, auth_token: @auth_token }, @headers
        assert_response 200
        body = JSON.parse(response.body).deep_symbolize_keys
        user = body[:data][:user]
        assert_equal 200, body[:status]
        #assert_equal 102, body[:code], "require additional information to complete registration" 
        assert_equal "can't be blank", body[:data][:errors][:email].join
        # Second step
        user[:email] = 'user@test.com'
        post '/users', { provider: @provider, auth_token: @auth_token, user: user }.to_json, @headers
        assert_response 201
        body = JSON.parse(response.body).deep_symbolize_keys
        assert_equal 201, body[:status]
        #assert_equal 101, body[:code], "successfully registered"
        assert_equal 'Yaroslav', body[:data][:user][:first_name]
        assert_equal 'Nychka', body[:data][:user][:last_name]
        assert_equal 'user@test.com', body[:data][:user][:email]
        assert_not_nil body[:data][:user][:access_token]
    end
    test "user registers by social network two step procedure" do
        extra = { bdate: nil, links: Array(Settings[@provider]['site']) }
        @data[:body] = attributes_for(:social_user, email: nil, url: Settings[@provider]['site']).merge(extra)
        Facebook.any_instance.stubs(:get_user_info).returns(@data)
        # First step
        get '/auth', { provider: @provider, auth_token: @auth_token }, @headers
        assert_response 200
        body = JSON.parse(response.body).deep_symbolize_keys
        assert_equal 200, body[:status]
        #assert_equal 102, body[:code], "require additional information to complete registration" 
        @data[:body].delete(:url)
        assert_equal @data[:body], body[:data][:user]
        assert_equal "can't be blank", body[:data][:errors][:email].join
        # Second step
        @data[:body][:email] = 'test@user.com'
        post '/users', { provider: @provider, auth_token: @auth_token, user: @data[:body] }.to_json, @headers
        assert_response 201
        body = JSON.parse(response.body).deep_symbolize_keys
        assert_equal 201, body[:status]
        #assert_equal 101, body[:code], "successfully registered"
        assert_equal 'test@user.com', body[:data][:user][:email]
        assert_equal 1, body[:data][:user][:links].count
        assert_equal Settings[@provider]['site'], body[:data][:user][:links].first
    end
    test "user connects Vkontakte two step procedure" do
        email = 'test@mail.com'
        user = create(:user, email: email)
        user.authentications << build(:authentication, provider: 'facebook')
        # mocking data
        @data[:body] = attributes_for(:social_user, email: nil, url: Settings['vkontakte']['site'])
        Vkontakte.any_instance.stubs(:get_user_info).returns(@data)
        # 1. First step procedure
        get '/auth', { provider: 'vkontakte', auth_token: Settings.vkontakte.access_token }, @headers
        body = JSON.parse(response.body).deep_symbolize_keys
        assert_equal 200, body[:status]
        #assert_equal 102, body[:code], "require additional information to complete registration"
        assert_equal 1, user.authentications.count
        # 2. User sends additional information to complete registration
        @data[:body][:email] = email
        post '/users', { provider: 'vkontakte', auth_token: Settings.vkontakte.access_token, user: @data[:body] }.to_json, @headers
        body = JSON.parse(response.body).deep_symbolize_keys
        assert_equal 200, body[:status]
        # 3. Facebook must connect to existing user
        #assert_equal 103, body[:code], "social network has been connected to user"
        assert_equal 2, user.authentications.count
    end
end