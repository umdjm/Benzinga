class ApplicationController < ActionController::Base
  helper_method :next_weekday
  helper_method :prev_weekday

  protect_from_forgery

  def next_weekday(original_date)
    StockResult.next_weekday(original_date)
  end

  def prev_weekday(original_date)
    one_day = 1.day
    weekdays = 1..5        # Monday is wday 1
    result = original_date
    result -= one_day until result < original_date && weekdays.member?(result.wday)
    result
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end
end
