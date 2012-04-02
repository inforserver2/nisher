require 'test_helper'

class Admin::JobsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get logs" do
    get :logs
    assert_response :success
  end

end
