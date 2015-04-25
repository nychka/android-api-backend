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
  end
end
