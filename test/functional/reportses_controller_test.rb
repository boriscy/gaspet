require 'test_helper'

class ReportsesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reportses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reports" do
    assert_difference('Reports.count') do
      post :create, :reports => { }
    end

    assert_redirected_to reports_path(assigns(:reports))
  end

  test "should show reports" do
    get :show, :id => reportses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => reportses(:one).to_param
    assert_response :success
  end

  test "should update reports" do
    put :update, :id => reportses(:one).to_param, :reports => { }
    assert_redirected_to reports_path(assigns(:reports))
  end

  test "should destroy reports" do
    assert_difference('Reports.count', -1) do
      delete :destroy, :id => reportses(:one).to_param
    end

    assert_redirected_to reportses_path
  end
end
