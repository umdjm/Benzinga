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
  puts "done."
end


desc "This task is called by the Heroku scheduler add-on"
task :create_next_day => :environment do
  puts "Createing Next Day..."
  StockResult.create_next_day
  puts "done."
end