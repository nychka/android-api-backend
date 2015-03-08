require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test "admin is not valid with no fields" do
    admin = Admin.new
    assert_not admin.valid?, "validation failed"
  end
  test "admin's factory is valid" do
    admin = build(:admin)
    assert admin.valid?, "all fields must presence and not empty"
  end
  test "creates valid admin" do
    admin = build(:admin)
    assert admin.save
  end
  test "admin's required field can't be blank" do
    admin = build(:admin, email: nil, password: nil)
    admin.valid?
    assert_match /can't be blank/, admin.errors[:email].join, "admin is not valid: email can't be blank"
    assert_match /can't be blank/, admin.errors[:password].join, "admin is not valid: password can't be blank"
  end
  test "admin's password must be at least 8 characters" do
    admin = build(:admin, password: '123456')
    admin.valid?
    assert_equal "is too short (minimum is 8 characters)", admin.errors[:password].join
  end
end
