require 'test_helper'

class SaldosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:saldos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create saldo" do
    assert_difference('Saldo.count') do
      post :create, :saldo => { }
    end

    assert_redirected_to saldo_path(assigns(:saldo))
  end

  test "should show saldo" do
    get :show, :id => saldos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => saldos(:one).to_param
    assert_response :success
  end

  test "should update saldo" do
    put :update, :id => saldos(:one).to_param, :saldo => { }
    assert_redirected_to saldo_path(assigns(:saldo))
  end

  test "should destroy saldo" do
    assert_difference('Saldo.count', -1) do
      delete :destroy, :id => saldos(:one).to_param
    end

    assert_redirected_to saldos_path
  end
end
