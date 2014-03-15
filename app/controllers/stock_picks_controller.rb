class StockPicksController < ApplicationController
  before_filter :authenticate_user!

  # GET /stock_picks
  # GET /stock_picks.json
  def index
    @stock_picks = current_user.stock_picks.all

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

    respond_to do |format|
      if @stock_pick.save
        format.html { redirect_to "/results/" + @stock_result.result_date.to_s, notice: "Pick Created"}
      else
        format.html { redirect_to "/results/" + @stock_result.result_date.to_s, notice: @stock_pick.errors.to_json}
      end
    end
  end

  # PUT /stock_picks/1
  # PUT /stock_picks/1.json
  def update
    @stock_pick = StockPick.find(params[:id])

    respond_to do |format|
      if @stock_pick.update_attributes(params[:stock_pick])
        format.html { redirect_to stock_picks_url, notice: 'Stock pick was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stock_pick.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_picks/1
  # DELETE /stock_picks/1.json
  def destroy
    @stock_pick = StockPick.find(params[:id])
    @stock_pick.destroy

    respond_to do |format|
      format.html { redirect_to stock_picks_url }
      format.json { head :no_content }
    end
  end
end
