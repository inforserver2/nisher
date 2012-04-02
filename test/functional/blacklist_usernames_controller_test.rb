require 'test_helper'

class BlacklistUsernamesControllerTest < ActionController::TestCase
  setup do
    @blacklist_username = blacklist_usernames(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blacklist_usernames)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blacklist_username" do
    assert_difference('BlacklistUsername.count') do
      post :create, blacklist_username: @blacklist_username.attributes
    end

    assert_redirected_to blacklist_username_path(assigns(:blacklist_username))
  end

  test "should show blacklist_username" do
    get :show, id: @blacklist_username.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blacklist_username.to_param
    assert_response :success
  end

  test "should update blacklist_username" do
    put :update, id: @blacklist_username.to_param, blacklist_username: @blacklist_username.attributes
    assert_redirected_to blacklist_username_path(assigns(:blacklist_username))
  end

  test "should destroy blacklist_username" do
    assert_difference('BlacklistUsername.count', -1) do
      delete :destroy, id: @blacklist_username.to_param
    end

    assert_redirected_to blacklist_usernames_path
  end
end
