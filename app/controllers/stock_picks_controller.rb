class StockPicksController < ApplicationController
  before_filter :authenticate_user!

  # GET /stock_picks
  # GET /stock_picks.json
  def index
    @stock_picks = current_user.stock_picks.all

    @current_leaders = User.order("current_rank asc").limit(10)
    @current_leaders << current_user unless @current_leaders.include?(current_user)

    @all_time_leaders = User.order("max_rank asc").limit(10)
    @all_time_leaders  << current_user unless @all_time_leaders.include?(current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stock_picks }
    end
  end

  # GET /stock_picks/1
  # GET /stock_picks/1.json
  def show
    @stock_pick = StockPick.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stock_pick }
    end
  end

  # GET /stock_picks/new
  # GET /stock_picks/new.json
  def new
    @stock_pick = current_user.stock_picks.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stock_pick }
    end
  end

  # GET /stock_picks/1/edit
  def edit
    @stock_pick = StockPick.find(params[:id])
  end

  # POST /stock_picks
  # POST /stock_picks.json
  def create
    @stock_result = StockResult.find(params[:stock_result_id])
    @stock_pick = current_user.stock_picks.build

    @stock_pick.assigned_price = @stock_result.price
    @stock_pick.stock_result_id = @stock_result.id
    @stock_pick.prediction = params[:prediction]
    duplicate_picks = StockPick.joins(:stock_result).where(:user_id => current_user.id, stock_results: {result_date: @stock_result.result_date})

    respond_to do |format|
      if !duplicate_picks.empty? || @stock_pick.save
        format.html { redirect_to "/results/" + @stock_result.result_date.to_s, notice: "Pick Created"}
      else
        format.html { redirect_to "/results/" + @stock_result.result_date.to_s, notice: @stock_pick.errors.to_json}
      end
    end
  end

end
