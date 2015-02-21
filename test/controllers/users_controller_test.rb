require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    DatabaseCleaner.start
  end
  def teardown
    DatabaseCleaner.clean
  end
  test "GET /users/:id" do
  	jack = create(:user)
  	susana = create(:user, first_name: 'Susana')

  	get :show, { access_token: jack.access_token, id: susana.id }
  	assert_response 200
  	body = JSON.parse(response.body).deep_symbolize_keys
  	assert_equal 200, body[:status]
  	assert_equal susana.first_name, body[:data][:user][:first_name]
  end
	test "POST /users" do
		user_params = attributes_for(:social_user)
		post :create, { provider: 'facebook', auth_token: Settings.facebook.access_token, user: user_params }
		assert_response 201
		body = JSON.parse(response.body).deep_symbolize_keys
		assert_equal 201, body[:status]
		assert_equal 101, body[:code], "successfully registered"
	end
	test "PUT /users" do
		user = create(:user, first_name: 'Yaroslav')
		user_params = { first_name: 'John' }
		put :update, { access_token: user.access_token, user: user_params }
		assert_response 200
		user.reload
		body = JSON.parse(response.body).deep_symbolize_keys
		assert_equal 200, body[:status]
		assert_equal 110, body[:code]
		assert_equal user.first_name, body[:data][:user][:first_name]
	end
	test "trying to update as unauthorized user" do
		put :update, { access_token: nil, user: attributes_for(:social_user) }
		assert_response 401
		body = JSON.parse(response.body).symbolize_keys
		assert_equal 401, body[:status]
		assert_equal 'Access denied: access_token is empty or invalid', body[:error_msg]
	end
	test "trying to update with invalid param" do
		user = create(:user)
		user_params = { email: nil }
		put :update, { access_token: user.access_token, user: user_params }
		assert_response 422
		body = JSON.parse(response.body).deep_symbolize_keys
		assert_equal 422, body[:status]
		assert_equal 104, body[:code]
		assert_equal "can't be blank", body[:data][:errors][:email].join
	end
	test "user not found" do
  	jack = create(:user)
  	get :show, { access_token: jack.access_token, id: 0 }
  	assert_response 404
  	body = JSON.parse(response.body).deep_symbolize_keys
  	assert_equal 404, body[:status]
  	assert_equal "user not found", body[:error_msg]
  end
end