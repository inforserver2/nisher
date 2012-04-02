require 'test_helper'

class Office::NetworkingControllerTest < ActionController::TestCase
  test "should get activate" do
    get :activate
    assert_response :success
  end

end
