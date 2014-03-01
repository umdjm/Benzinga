require 'test_helper'

class StockPicksControllerTest < ActionController::TestCase
  setup do
    @stock_pick = stock_picks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_picks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_pick" do
    assert_difference('StockPick.count') do
      post :create, stock_pick: { direction: @stock_pick.direction, pick_date: @stock_pick.pick_date, result: @stock_pick.result, stock: @stock_pick.stock }
    end

    assert_redirected_to stock_pick_path(assigns(:stock_pick))
  end

  test "should show stock_pick" do
    get :show, id: @stock_pick
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_pick
    assert_response :success
  end

  test "should update stock_pick" do
    put :update, id: @stock_pick, stock_pick: { direction: @stock_pick.direction, pick_date: @stock_pick.pick_date, result: @stock_pick.result, stock: @stock_pick.stock }
    assert_redirected_to stock_pick_path(assigns(:stock_pick))
  end

  test "should destroy stock_pick" do
    assert_difference('StockPick.count', -1) do
      delete :destroy, id: @stock_pick
    end

    assert_redirected_to stock_picks_path
  end
end
