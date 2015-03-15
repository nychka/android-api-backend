require 'test_helper'

class AdGeneratorTest < ActiveSupport::TestCase
  test "respond to generate_by" do
    assert_respond_to AdGenerator, :generate
  end
  test "generate_by" do
    ads_list = create_list(:ad, 5)
    ads = AdGenerator.generate
    assert_equal Settings.ads_limit, ads.length
  end
  test "limit ads" do
    ads_list = create_list(:ad, 5)
    ads = AdGenerator.generate limit: 3
    assert_equal 3, ads.length
  end
  test "show ads within user's radius" do
    user = create(:geo_user)
    place = create(:geo_place)
    create_list(:ad, 5)
    ad_list = create_list(:ad, 2, place_id: place.id)
    ads = AdGenerator.generate current_user: user
    assert_equal Settings.ads_limit, ads.length
    ads.each do |ad|
     assert ad_list.include? ad
    end
  end
  test "show ads out of user's radius" do
    user = create(:user)
    place = create(:place)
    create_list(:ad, 5)
    ad_list = create_list(:ad, 2, place_id: place.id)
    ads = AdGenerator.generate current_user: user
    assert_equal Settings.ads_limit, ads.length
  end
end