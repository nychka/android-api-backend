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
  test "should create admin_ad" do
    ad = attributes_for(:ad)
    assert_difference('Ad.count', 1) do
      post :create, ad: ad
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
