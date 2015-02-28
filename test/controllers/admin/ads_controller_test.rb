require 'test_helper'

class Admin::AdsControllerTest < ActionController::TestCase
  setup do
    @admin_ad = admin_ads(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:admin_ads)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create admin_ad" do
  #   assert_difference('Admin::Ad.count') do
  #     post :create, admin_ad: { name: @admin_ad.name, photo: @admin_ad.photo, place_id: @admin_ad.place_id, price: @admin_ad.price }
  #   end

  #   assert_redirected_to admin_ad_path(assigns(:admin_ad))
  # end

  # test "should show admin_ad" do
  #   get :show, id: @admin_ad
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @admin_ad
  #   assert_response :success
  # end

  # test "should update admin_ad" do
  #   patch :update, id: @admin_ad, admin_ad: { name: @admin_ad.name, photo: @admin_ad.photo, place_id: @admin_ad.place_id, price: @admin_ad.price }
  #   assert_redirected_to admin_ad_path(assigns(:admin_ad))
  # end

  # test "should destroy admin_ad" do
  #   assert_difference('Admin::Ad.count', -1) do
  #     delete :destroy, id: @admin_ad
  #   end

  #   assert_redirected_to admin_ads_path
  # end
end
