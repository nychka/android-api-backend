require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:age)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:email)
  should have_many(:authentications)

  test "user is not valid with no fields" do
    user = User.new
    assert_not user.valid?, "validation failed"
  end
  test "user's factory is valid" do
    user = build(:user)
    assert user.valid?, "all fields must presence and not empty"
  end
  test "user is not valid with empty first_name" do
    user = build(:user, first_name: '')
    assert_not user.valid?
  end
  test "creates valid user" do
    user = build(:user)
    assert user.save
  end
  test "user's required field can't be blank" do
    user = build(:user, age: nil)
    user.valid?
    assert_match /can't be blank/, user.errors[:age].join, "user is not valid: age can't be blank"
  end
  test "user is not valid without unique access token" do
    double_token = '123456789'
    user  = create(:user, access_token: double_token)
    assert_raise ActiveRecord::RecordInvalid do
      create(:user, access_token: double_token)
    end
  end
  test "user authorizes by access token" do
    user = create(:user)
    access_token = user.access_token
    assert User.authorize_by(access_token: access_token)
  end
  test "regenerate access token after successful authorization" do
    user = create(:user)
    access_token = user.access_token
    assert_equal user, User.authorize_by(access_token: access_token)
    user.reload
    assert_not_equal access_token, user.access_token, "acces token must regenerate after successful authrorization"
  end
  test "user authorizes by provider and auth_token" do
    user = create(:user)
    authentication = create(:authentication, provider: 'facebook', user_id: user.id)
    assert_equal user, User.authorize_by(provider: 'facebook', auth_token: authentication.auth_token)
  end
  test "user authorizes by invalid provider and auth_token" do
    user = create(:user)
    authentication = create(:authentication, provider: 'facebook', user_id: user.id)
    assert_nil User.authorize_by(provider: 'twitter', auth_token: authentication.auth_token)
  end
end