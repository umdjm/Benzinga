desc "This task is called by the Heroku scheduler add-on"
task :update_prices => :environment do
  puts "Updating prices..."
  StockResult.update_prices
  puts "done."
end