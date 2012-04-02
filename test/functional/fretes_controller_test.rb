require 'test_helper'

class FretesControllerTest < ActionController::TestCase
  setup do
    @frete = fretes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fretes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create frete" do
    assert_difference('Frete.count') do
      post :create, frete: @frete.attributes
    end

    assert_redirected_to frete_path(assigns(:frete))
  end

  test "should show frete" do
    get :show, id: @frete.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @frete.to_param
    assert_response :success
  end

  test "should update frete" do
    put :update, id: @frete.to_param, frete: @frete.attributes
    assert_redirected_to frete_path(assigns(:frete))
  end

  test "should destroy frete" do
    assert_difference('Frete.count', -1) do
      delete :destroy, id: @frete.to_param
    end

    assert_redirected_to fretes_path
  end
end
