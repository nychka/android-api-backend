require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    DatabaseCleaner.start
    @request.headers["Content-Type"] = "application/json"
    @request.headers["Accept"] = "application/json"
  end
  def teardown
    DatabaseCleaner.clean
  end
  test "bad request format" do
    @request.headers["Accept"] = "application/html"
    @request.headers['Content-Type'] = 'application/html'
    jack = create(:user)
    susana = create(:user, first_name: 'Susana')
    get :show, { access_token: jack.access_token, id: susana.id }
    assert_response 400
    body = JSON.parse(response.body).symbolize_keys
    assert_equal 400, body[:status]
    assert_match /Bad request/, body[:error_msg]
  end
  test "GET /users/:id" do
  	jack = create(:user)
  	susana = create(:user, first_name: 'Susana')
    susana_json = rabl_render(susana, 'users/guest_user', current_user: jack)
  	get :show, { access_token: jack.access_token, id: susana.id }
  	assert_response 200
  	body = JSON.parse(response.body).deep_symbolize_keys
  	assert_equal 200, body[:status]
  	assert_equal susana_json, body[:data][:user]
  end
	test "POST /users" do
		user_params = attributes_for(:social_user)
		post :create, { provider: 'facebook', auth_token: Settings.facebook.access_token, user: user_params }
		assert_response 201
		body = JSON.parse(response.body).deep_symbolize_keys
		assert_equal 201, body[:status]
		#assert_equal 101, body[:code], "successfully registered"
	end
	test "PUT /users" do
		user = create(:user, first_name: 'Yaroslav')
		user_params = { first_name: 'John' }
		put :update, { access_token: user.access_token, user: user_params }
		assert_response 200
		user.reload
    user_json = rabl_render(user, 'users/user')
		body = JSON.parse(response.body).deep_symbolize_keys
		assert_equal 200, body[:status]
		assert_equal user_json, body[:data][:user]
	end
  test "user updates links" do
    user = create(:user, first_name: 'Rudolf')
    links = ['foo', 'bar']
    user_params = { last_name: 'Nuts', links: links }
    put :update, { access_token: user.access_token, user: user_params }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal links, body[:data][:user][:links]
  end
  test "update user with access_token inside user" do
    user = create(:user, first_name: 'Ivan')
    user.first_name = 'Petro'
    put :update, { user: user.attributes }
    assert_response 200
    user.reload
    user_json = rabl_render(user, 'users/user')
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal 'Petro', body[:data][:user][:first_name]
    assert_equal user_json, body[:data][:user]
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
		assert_equal "can't be blank", body[:data][:errors][:email].join
	end
  test "update user with required params" do
    user = create(:user)
    user_params = { first_name: 'John', last_name: 'Rain', email: 'john@snow.com', city: nil, gender: 0 }
    user_params[:access_token] = user.access_token
    put :update, { user: user_params }
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 422, body[:status]
    assert_equal 1, body[:data][:errors].count
    assert_equal "is not included in the list", body[:data][:errors][:gender].join
  end
	test "user not found" do
  	jack = create(:user)
  	get :show, { access_token: jack.access_token, id: 0 }
  	assert_response 404
  	body = JSON.parse(response.body).deep_symbolize_keys
  	assert_equal 404, body[:status]
  	assert_equal "user not found", body[:error_msg]
  end
  test "show user with extra ads" do
    jack = create(:user)
    susana = create(:user, first_name: 'Susana')
    ad = create(:ad)
    place = ad.place
    ad_json = rabl_render(ad, 'ads/ad')
    susana_json = rabl_render(susana, 'users/guest_user', current_user: jack)
    get :show, { access_token: jack.access_token, id: susana.id }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal susana_json, body[:data][:user]
    assert body[:data][:ads].kind_of? Array
    assert_equal ad_json, body[:data][:ads].first
  end
  test "show guest user without access_token" do
    jack = create(:user)
    susana = create(:user, first_name: 'Susana')
    ad = create(:ad)
    ad_json = rabl_render(ad, 'ads/ad')
    susana_json = rabl_render(susana, 'users/guest_user', current_user: jack)

    get :show, { access_token: jack.access_token, id: susana.id }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_nil body[:data][:user][:access_token]
    assert_equal susana_json, body[:data][:user]
    assert body[:data][:ads].kind_of? Array
    assert_equal ad_json, body[:data][:ads].first
  end
  test "show ad in user's radius" do
    jack = create(:user, latitude: 49.8385295, longitude: 24.0548934, city: nil)
    susana = create(:user, first_name: 'Susana')
    susana_json = rabl_render(susana, 'users/guest_user', current_user: jack)
    place = create(:place, latitude: 49.8395979, longitude: 24.051139) # 0.294 km from user
    create_list(:ad, 10)
    ad = create(:ad, place_id: place.id)
    ad_json = rabl_render(ad, 'ads/ad')

    distance = jack.distance_to(place)
    assert_equal 0.294, distance.round(3)

    get :show, { access_token: jack.access_token, id: susana.id }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal susana_json, body[:data][:user]
    assert_equal ad_json, body[:data][:ads].first
  end
end