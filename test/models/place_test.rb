require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  should validate_presence_of :name
  should validate_presence_of :phone
  should have_many :ads

  test "is not valid with no fields" do
    place = Place.new
    assert_not place.valid?, "validation failed"
  end
  test "factory is valid" do
    place = build(:place)
    assert place.valid?, "all fields must presence and not empty"
  end
  test "place is not valid with empty first_name" do
    place = build(:place, name: '')
    assert_not place.valid?
  end
  test "should create valid place" do
    place = build(:place)
    assert place.save
  end
  test "place's required field can't be blank" do
    place = build(:place, phone: nil)
    place.valid?
    assert_match /can't be blank/, place.errors[:phone].join, "place is not valid: phone can't be blank"
  end
end