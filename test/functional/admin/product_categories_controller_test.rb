require 'test_helper'

class Admin::ProductCategoriesControllerTest < ActionController::TestCase
  setup do
    @admin_product_category = admin_product_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_product_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_product_category" do
    assert_difference('Admin::ProductCategory.count') do
      post :create, admin_product_category: @admin_product_category.attributes
    end

    assert_redirected_to admin_product_category_path(assigns(:admin_product_category))
  end

  test "should show admin_product_category" do
    get :show, id: @admin_product_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_product_category.to_param
    assert_response :success
  end

  test "should update admin_product_category" do
    put :update, id: @admin_product_category.to_param, admin_product_category: @admin_product_category.attributes
    assert_redirected_to admin_product_category_path(assigns(:admin_product_category))
  end

  test "should destroy admin_product_category" do
    assert_difference('Admin::ProductCategory.count', -1) do
      delete :destroy, id: @admin_product_category.to_param
    end

    assert_redirected_to admin_product_categories_path
  end
end
