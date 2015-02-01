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
end