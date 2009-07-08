require 'test_helper'

class PreciosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:precios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create precio" do
    assert_difference('Precio.count') do
      post :create, :precio => { }
    end

    assert_redirected_to precio_path(assigns(:precio))
  end

  test "should show precio" do
    get :show, :id => precios(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => precios(:one).to_param
    assert_response :success
  end

  test "should update precio" do
    put :update, :id => precios(:one).to_param, :precio => { }
    assert_redirected_to precio_path(assigns(:precio))
  end

  test "should destroy precio" do
    assert_difference('Precio.count', -1) do
      delete :destroy, :id => precios(:one).to_param
    end

    assert_redirected_to precios_path
  end
end
