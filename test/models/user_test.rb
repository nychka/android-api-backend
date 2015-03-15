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
  test "user has many links" do
    user = build(:user)
    user.links = [Settings.facebook.site, Settings.vkontakte.site, Settings.gplus.site ]
    assert user.valid?
  end
  test "bdate" do
    user = build(:model_user, bdate: Date.parse('1993-02-17'))
    assert user.valid?
    assert_equal '1993-02-17', user.bdate.as_json
  end
  test "read links" do
    socials = ['foo', 'bar']
    user = build(:user, links: socials)
    assert_equal socials, user.links
    assert_equal 2, user.links.count
    assert_equal socials, user.links
  end
  test "write links" do
    user = build(:user)
    links = ['foo', 'bar']
    user.links = links
    assert_equal 2, user.links.count
    assert_equal links, user.links
  end
  test "#add_social_network" do
    user = create(:user)
    auth = create(:authentication, provider: 'facebook', auth_token: 'XYZ', user_id: user.id)
    params = { provider: 'facebook', user_id: user.id, auth_token: 'MNL' }
    assert_difference 'Authentication.count', 0 do
      user.add_social_network(params)
    end
    auth.reload
    assert_equal auth, Authentication.find_by(params)
  end
  test "get nearby users" do
    user = create(:geo_user)
    list = create_list(:user, 5) # distance_to user 1.810 km
    nearby_users = User.nearby(user)
    assert_equal 0, nearby_users.length
    place = attributes_for(:geo_place) # distance_to user 0.294 km
    nearby_user = create(:geo_user, latitude: place[:latitude], longitude: place[:longitude])
    nearby_users = User.nearby(user)
    assert_equal 1, nearby_users.length
    assert_equal nearby_user, nearby_users.first
  end
end
