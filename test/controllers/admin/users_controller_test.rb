require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @admin = create(:admin)
    sign_in :admin, @admin
  end
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
    assert_template layout: 'layouts/application'
  end
  test "should create admin_user" do
    assert_difference('User.count', 1) do
      user = attributes_for(:user)
      post :create, user: user
    end
    assert_redirected_to admin_user_path(assigns(:user))
    assert_equal "User was successfully created.", flash[:notice]
  end
  test "should show admin_user" do
    user = create(:user)
    get :show, id: user
    assert_response :success
    assert_template :show
  end
  test "should get edit" do
    user = create(:user)
    get :edit, id: user
    assert_response :success
    assert_template :edit
  end
  test "should update admin_user" do
    user = create(:user)
    put :update, id: user, user: { last_name: 'Norris', age: 99 }
    assert_redirected_to admin_user_path(assigns(:user))
    assert_equal "User was successfully updated.", flash[:notice]
  end
  test "should destroy admin_user" do
    user = create(:user)
    assert_difference('User.count', -1) do
      delete :destroy, id: user
    end
    assert_redirected_to admin_users_path
    assert_equal "User was successfully destroyed.", flash[:notice]
  end
end
