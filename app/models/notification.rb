class Notification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :notification_date, :template, :status

  def self.SendMorningEmails
    return unless CONFIG[:weekdays].member?(current_date.wday) && !CONFIG[:market_closed].member?(current_date.yday)
    User.where("(id % 2 = 0)").each do |user|
        EventsMailer.send_mail(user, "morning-results")
    end
  end

  def self.SendNightlyEmails
    return unless CONFIG[:weekdays].member?(current_date.tomorrow.wday) && !CONFIG[:market_closed].member?(current_date.tomorrow.yday)
    User.where("(id % 2 = 1)").each do |user|
      EventsMailer.send_mail(user, "nightly-results")
    end
  end

  def self.current_date
    Time.now.in_time_zone("America/New_York").to_date
  end

end
