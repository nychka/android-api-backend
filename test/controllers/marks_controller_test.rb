require 'test_helper'

class MarksControllerTest < ActionController::TestCase
  def setup
    DatabaseCleaner.start
    @request.headers["Content-Type"] = "application/json"
    @request.headers["Accept"] = "application/json"
  end
  def teardown
    DatabaseCleaner.clean
  end
  test "GET /marks" do
    user = create(:user)
    create_list(:mark, 5, user_id: user.id)
    marked_users = user.marked_users
    mark_json = rabl_render(marked_users, 'marks/show')
    get :index, { access_token: user.access_token }
    assert_response 200
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 200, body[:status]
    assert_equal mark_json[:data][:users], body[:data][:users]
  end
  test "POST /marks" do
    user = create(:user)
    marked_user = create(:user)
    mark_json = rabl_render(marked_user, 'marks/create')
    mark_attributes = attributes_for(:mark, marked_user_id: marked_user.id)
    post :create, { access_token: user.access_token, user_id: marked_user.id }
    assert_equal marked_user, user.marked_users.first
    assert_response 201
    body = JSON.parse(response.body).deep_symbolize_keys
    assert_equal 201, body[:status]
    assert_equal mark_json[:data][:user], body[:data][:user]
  end
  test "DELETE /marks" do
    user = create(:user)
    marked_user = create(:user)
    mark = create(:mark, user_id: user.id, marked_user_id: marked_user.id)
    assert_equal 1, user.marks.count
    delete :destroy, { access_token: user.access_token, id: marked_user.id }
    assert_equal 0, user.marks.count
    assert_response 204
    body = JSON.parse(response.body).symbolize_keys
    assert_equal 204, body[:status]
    assert_nil body[:data]
  end
end
