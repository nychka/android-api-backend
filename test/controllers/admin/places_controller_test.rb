require 'test_helper'

class Admin::PlacesControllerTest < ActionController::TestCase
  setup do
    @admin_place = admin_places(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:admin_places)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create admin_place" do
  #   assert_difference('Admin::Place.count') do
  #     post :create, admin_place: { lat: @admin_place.lat, lng: @admin_place.lng, name: @admin_place.name, phone: @admin_place.phone }
  #   end

  #   assert_redirected_to admin_place_path(assigns(:admin_place))
  # end

  # test "should show admin_place" do
  #   get :show, id: @admin_place
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @admin_place
  #   assert_response :success
  # end

  # test "should update admin_place" do
  #   patch :update, id: @admin_place, admin_place: { lat: @admin_place.lat, lng: @admin_place.lng, name: @admin_place.name, phone: @admin_place.phone }
  #   assert_redirected_to admin_place_path(assigns(:admin_place))
  # end

  # test "should destroy admin_place" do
  #   assert_difference('Admin::Place.count', -1) do
  #     delete :destroy, id: @admin_place
  #   end

  #   assert_redirected_to admin_places_path
  # end
end
