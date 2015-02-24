require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
    user = build(:user, email: nil)
    user.valid?
    assert_match /can't be blank/, user.errors[:email].join, "user is not valid: email can't be blank"
  end
  test "user is not valid without unique access token" do
    user  = create(:user, access_token: '123456789')
    assert_raise ActiveRecord::RecordInvalid do
      create(:user, access_token: user.access_token)
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
  test "creates access token after save" do
    user_params = attributes_for(:social_user)
    user_params.delete(:url)
    user = User.create(user_params)
    assert_not_nil user.access_token
  end
  test "user has not valid gender" do
    user = build(:user, gender: 3)
    user.valid?
    assert_match /is not included in the list/, user.errors[:gender].join
  end
  test "user has many socials" do
    user = build(:user)
    user.socials = { facebook: Settings.facebook.site, vkontakte: Settings.vkontakte.site, gplus: Settings.gplus.site }
    assert user.valid?
  end
  test "user as_json attributes" do
    user = create(:model_user)
    json = user.as_json
    refute json.has_key? :updated_at
    refute json.has_key? :created_at
  end
  test "user's links must be an Array" do
    user = create(:model_user)
    json = user.as_json
    assert json['links'].kind_of? Array
    assert_equal 3, json['links'].count
    assert_equal user.socials.values, json['links']
  end
  test "bdate" do
    user = build(:model_user, bdate: Date.parse('1993-02-17'))
    assert user.valid?
    assert_equal '17/02/1993', user.bdate.as_json
    assert_equal '1993-02-17', user.read_attribute(:bdate).as_json
  end
end