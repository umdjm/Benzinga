module ApplicationHelper

  def is_market_prep_time
    current_time = Time.now
    return false unless CONFIG[:weekdays].member?(current_time.wday)
    return false unless !CONFIG[:market_closed].member?(current_time.yday)
    return false unless current_time < Time.now.in_time_zone("America/New_York").change(:hour => 9, :minute => 30)
    return false unless current_time > Time.now.in_time_zone("America/New_York").change(:hour => 8, :minute => 0)
    return true
  end
end
