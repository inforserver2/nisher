require 'test_helper'

class ViaControllerTest < ActionController::TestCase
  test "should get boleto" do
    get :boleto
    assert_response :success
  end

  test "should get pagseguro" do
    get :pagseguro
    assert_response :success
  end

  test "should get paypal" do
    get :paypal
    assert_response :success
  end

end
