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
  test "scope with_ads" do
    place = create(:place)
    assert_equal 0, Place.with_ads.length
    create(:ad, place_id: place.id)
    assert_equal 1, Place.with_ads.length
    assert place, Place.with_ads.first
  end
  test "scope within_radius" do
    user = create(:geo_user)
    place = create(:geo_place)
    distance = user.distance_to(place)
    assert_equal 0.294, distance.round(3)
    assert_equal 0, Place.with_ads.length
    create(:ad, place_id: place.id)
    assert_equal place, Place.with_ads.first
    place_near_user = Place.near(user, 0.3)
    assert_equal 1, place_near_user.length
    assert_equal place, place_near_user.first
    places_within_radius = Place.within_radius(user, 0.3) # default radius equals 0.5
    assert_equal 1, places_within_radius.length
    assert_equal place, places_within_radius.first
  end
end