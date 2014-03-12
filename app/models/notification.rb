class Notification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :notification_date, :template, :status

  def self.SendBatchEmails
    User.all.each do |user|
        EventsMailer.send_mail(user, "testemail")
    end
  end
end
