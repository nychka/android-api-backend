require 'test_helper'

class Admin::AdsControllerTest < ActionController::TestCase
  setup do
    @admin = create(:admin)
    sign_in :admin, @admin
  end
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ads)
  end
  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
    assert_template layout: 'layouts/application'
  end
  test "should create ad with new place" do
    ad_params = { name: 'Капучіно', price: '18грн.', photo: 'http://someimage.com/image.png' }
    place_params = { name: 'Японахата', phone: '0323387945', lng: 0.123234243, lat: 0.12232323 }
    assert_difference(['Ad.count', 'Place.count'], 1) do
      post :create, ad: ad_params, place: place_params
    end
    assert_redirected_to admin_ad_path(assigns(:ad))
    assert_equal "Ad was successfully created.", flash[:notice]
  end
  test "should not create ad with empty place" do
    ad_params = { name: 'Капучіно', price: '18грн.', photo: 'http://someimage.com/image.png' }
    place_params = { name: '', phone: '0323387945', lng: 0.123234243, lat: 0.12232323 }
    assert_difference(['Ad.count', 'Place.count'], 0) do
      post :create, ad: ad_params, place: place_params
    end
    assert_template :new
  end
  test "should not create ad with empty product name" do
    ad_params = { name: '', price: '18грн.', photo: 'http://someimage.com/image.png' }
    place_params = { name: 'Store', phone: '0323387945', lng: 0.123234243, lat: 0.12232323 }
    assert_difference('Ad.count', 0) do
      post :create, ad: ad_params, place: place_params
    end
    assert_template :new
  end
  test "should create ad with existing place" do
    place = create(:place)
    ad_params = { name: 'Капучіно', price: '18грн.', photo: 'http://someimage.com/image.png', place_id: place.id }
   
    assert_difference(['Place.count'], 0) do
      post :create, ad: ad_params, place: place.attributes
    end
    assert_redirected_to admin_ad_path(assigns(:ad))
    assert_equal "Ad was successfully created.", flash[:notice]
  end
  test "should show admin_ad" do
    ad = create(:ad)
    get :show, id: ad
    assert_response :success
    assert_template :show
  end
  test "should get edit" do
    ad = create(:ad)
    get :edit, id: ad
    assert_response :success
    assert_template :edit
  end
  test "should update admin_ad" do
    ad = create(:ad)
    put :update, id: ad, ad: { name: 'Lipton Tea' }
    assert_redirected_to admin_ad_path(assigns(:ad))
    assert_equal "Ad was successfully updated.", flash[:notice]
  end
  test "should destroy admin_ad" do
    ad = create(:ad)
    assert_difference('Ad.count', -1) do
      delete :destroy, id: ad
    end
    assert_redirected_to admin_ads_path
    assert_equal "Ad was successfully destroyed.", flash[:notice]
  end
end
