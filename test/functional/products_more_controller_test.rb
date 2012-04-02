require 'test_helper'

class ProductsMoreControllerTest < ActionController::TestCase
  test "should get fillup" do
    get :fillup
    assert_response :success
  end

  test "should get nutrameal" do
    get :nutrameal
    assert_response :success
  end

  test "should get alef" do
    get :alef
    assert_response :success
  end

  test "should get mgd" do
    get :mgd
    assert_response :success
  end

  test "should get mgn" do
    get :mgn
    assert_response :success
  end

end
