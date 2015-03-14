require 'test_helper'

class AdTest < ActiveSupport::TestCase
  should validate_presence_of :name
  should validate_presence_of :place_id
  should belong_to :place

  test "is not valid with no fields" do
    ad = Ad.new
    assert_not ad.valid?, "validation failed"
  end
  test "factory is valid" do
    ad = build(:ad)
    assert ad.valid?, "all fields must presence and not empty"
  end
  test "ad is not valid with empty first_name" do
    ad = build(:ad, name: '')
    assert_not ad.valid?
  end
  test "should create valid ad" do
    ad = build(:ad)
    assert ad.save
  end
  test "ad's required field can't be blank" do
    ad = build(:ad, place_id: nil)
    ad.valid?
    assert_match /can't be blank/, ad.errors[:place_id].join, "ad is not valid: place_id can't be blank"
  end
  test "respond to random" do
    assert_respond_to Ad, :random
  end
end