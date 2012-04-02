require 'test_helper'

class LayoutsControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get content_sidebar" do
    get :content_sidebar
    assert_response :success
  end

  test "should get content_sidebar" do
    get :content_sidebar
    assert_response :success
  end

  test "should get content_wide" do
    get :content_wide
    assert_response :success
  end

  test "should get office_sidebar" do
    get :office_sidebar
    assert_response :success
  end

  test "should get office_wide" do
    get :office_wide
    assert_response :success
  end

end
