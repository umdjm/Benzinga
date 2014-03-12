require 'mandrill'

class EventsMailer < ActionMailer::Base
  def call_mandrill template, template_content, message
    mandrill = Mandrill::API.new
    mandrill.messages.send_template template, template_content, message
  end

  def send_mail user, template
    message = {
        :to=>[
            {
                :email=> user.email,
                :name=> user.name
            }
        ],
        :global_merge_vars=> [
            {
                :name => 'FIRST_NAME',
                :content => user.name.titleize
            },
            {
                :name => 'EMAIL_ADDRESS',
                :content => user.email
            }
        ]
    }

    template_content = []
    status = "sending"
    notification = user.notifications.create :notification_date => Time.now, :template => template, :status => status
    begin
      call_mandrill template, template_content, message
      status = "sent"
    rescue Exception => e
      status = "failed #{e}"
    end
    notification.status = status
    notification.save
  end

end
