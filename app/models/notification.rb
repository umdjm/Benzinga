class Notification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :notification_date, :template, :status

  def self.SendBatchEmails
    return unless CONFIG[:weekdays].member?(Date.current.wday) && !CONFIG[:market_closed].member?(Date.current.yday)
    User.all.each do |user|
        EventsMailer.send_mail(user, "testemail")
    end
  end
end
