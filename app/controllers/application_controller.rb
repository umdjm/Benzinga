class ApplicationController < ActionController::Base
  helper_method :next_weekday
  helper_method :prev_weekday

  protect_from_forgery

  def next_weekday(original_date)
    StockResult.next_weekday(original_date)
  end

  def prev_weekday(original_date)
    StockResult.prev_weekday(original_date)
  end

end
