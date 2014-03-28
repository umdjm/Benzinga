class StockResultsController < ApplicationController
  before_filter :authenticate_user!

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
    @max_date = Time.parse(StockResult.maximum(:result_date).to_s + " 15:00:00 -0400")

    if params[:day].nil?
      @curr_day = @max_date
    else
      begin
        @curr_day = Time.parse(params[:day])
      rescue Exception => e
        @curr_day = @max_date
      end
    end

    @last_call = @curr_day.in_time_zone("America/New_York").change(:hour => 15)
    @market_open = (@last_call > Time.now)

    @current_leaders = User.order("current_rank asc").limit(10)
    @current_leaders << current_user unless @current_leaders.include?(current_user)

    @all_time_leaders = User.order("max_rank asc").limit(10)
    @all_time_leaders  << current_user unless @all_time_leaders.include?(current_user)

    @results = StockResult.includes(:stock_picks).where("result_date = '#{@curr_day}' AND (stock_picks.user_id IS NULL OR stock_picks.user_id = #{current_user.id})" )

    @allow_prediction = @market_open
    @results.each do |result|
      @pick = result.stock_picks.first unless result.stock_picks.first.nil?
      @allow_prediction = false unless result.closing_price.nil?
      @allow_prediction = false unless result.stock_picks.first.nil?
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
