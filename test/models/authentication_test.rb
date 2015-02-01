require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  should belong_to :user
  should validate_presence_of(:user_id)
  should validate_presence_of(:provider)
  should validate_presence_of(:auth_token)

  test "factory is valid" do
    auth = build(:authentication)
    assert auth.valid?, "factory is valid"
  end
  test "creates authentication" do
    auth = build(:authentication)
    assert auth.save
  end
  test "doesn't create invalid authentication" do
    auth = build(:authentication, user_id: nil)
    assert_not auth.valid?, "invalid authentication without user_id"
  end
end