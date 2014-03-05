class StockResultsController < ApplicationController

  before_filter :authorize

  # GET /stock_results
  # GET /stock_results.json
  def index
    @stock_results = StockResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stock_results }
    end
  end

  def show
    @max_date = Time.parse(StockResult.maximum(:result_date).to_s)

    if params[:day].nil?
      @curr_day = @max_date
    else
      @curr_day = Time.parse(params[:day])
    end

    @last_call = @curr_day.change(:hour => 15)
    @market_open = (@last_call > Time.now)

    @current_leaders = User.order("current_streak desc, max_streak desc").limit(20)
    @all_time_leaders = User.order("max_streak desc, current_streak desc").limit(20)
    @results = StockResult.includes(:stock_picks).where(:result_date => @curr_day)

    @allow_prediction = @market_open
    @results.each do |result|
      @allow_prediction = false unless result.closing_price.nil?
      @allow_prediction = false unless result.stock_picks.first.nil?
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /stock_results/new
  # GET /stock_results/new.json
  def new
    @stock_result = StockResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stock_result }
    end
  end

  # GET /stock_results/1/edit
  def edit
    @stock_result = StockResult.find(params[:id])
  end

  # POST /stock_results
  # POST /stock_results.json
  def create
    @stock_result = StockResult.new(params[:stock_result])

    respond_to do |format|
      if @stock_result.save
        format.html { redirect_to stock_results_url, notice: 'Stock result was successfully created.' }
        format.json { render json: @stock_result, status: :created, location: @stock_result }
      else
        format.html { render action: "new" }
        format.json { render json: @stock_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stock_results/1
  # PUT /stock_results/1.json
  def update
    @stock_result = StockResult.find(params[:id])

    respond_to do |format|
      if @stock_result.update_attributes(params[:stock_result])

        format.html { redirect_to stock_results_url, notice: 'Stock result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stock_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_results/1
  # DELETE /stock_results/1.json
  def destroy
    @stock_result = StockResult.find(params[:id])
    @stock_result.destroy

    respond_to do |format|
      format.html { redirect_to stock_results_url }
      format.json { head :no_content }
    end
  end
end
