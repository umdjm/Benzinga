desc "This task is called by the Heroku scheduler add-on"
task :update_all => :environment do
  puts "Updating prices..."
  StockResult.update_prices
  puts "Updating all streaks..."
  User.update_all_streaks
  puts "Creating Next Day..."
  StockResult.create_next_day
  puts "done."
end

desc "This task is called by the Heroku scheduler add-on"
task :update_prices => :environment do
  puts "Updating prices..."
  StockResult.update_prices
  puts "done."
end

desc "This task is called by the Heroku scheduler add-on"
task :update_streaks => :environment do
  puts "Updating all streaks..."
  User.update_all_streaks
  puts "Updating all rankings..."
  User.update_all_rankings
  puts "done."
end


desc "This task is called by the Heroku scheduler add-on"
task :create_next_day => :environment do
  puts "Creating Next Day..."
  StockResult.create_next_day
  puts "done."
end

desc "This task is called by the Heroku scheduler add-on"
task :send_morning_email => :environment do
  puts "Sending email..."
  Notification.SendMorningEmails
  puts "done."
end


desc "This task is called by the Heroku scheduler add-on"
task :send_nightly_email => :environment do
  puts "Sending email..."
  Notification.SendNightlyEmails
  puts "done."
end