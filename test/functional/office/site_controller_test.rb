require 'test_helper'

class Office::SiteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get downloads" do
    get :downloads
    assert_response :success
  end

  test "should get banners" do
    get :banners
    assert_response :success
  end

end
