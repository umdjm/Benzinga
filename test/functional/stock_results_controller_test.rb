require 'test_helper'

class StockResultsControllerTest < ActionController::TestCase
  setup do
    @stock_result = stock_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_result" do
    assert_difference('StockResult.count') do
      post :create, stock_result: { direction: @stock_result.direction, result_date: @stock_result.result_date, stock: @stock_result.stock }
    end

    assert_redirected_to stock_result_path(assigns(:stock_result))
  end

  test "should show stock_result" do
    get :show, id: @stock_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_result
    assert_response :success
  end

  test "should update stock_result" do
    put :update, id: @stock_result, stock_result: { direction: @stock_result.direction, result_date: @stock_result.result_date, stock: @stock_result.stock }
    assert_redirected_to stock_result_path(assigns(:stock_result))
  end

  test "should destroy stock_result" do
    assert_difference('StockResult.count', -1) do
      delete :destroy, id: @stock_result
    end

    assert_redirected_to stock_results_path
  end
end
