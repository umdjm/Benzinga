module Helpers
  @@sequence_num = 1
  def pause
    print "Press Return to continue"
    STDIN.getc
  end

  def today
    Time.now.in_time_zone("America/New_York")
  end

  def sign_up
    visit new_user_registration_path
    email =  "test#{@@sequence_num+=1}@test.com"
    fill_in "Email", :with => email
    fill_in "Name", :with => "Sample Name"
    fill_in "Password", :with => "password"
    fill_in "Password confirmation", :with => "password"
    click_button "Sign Up"
    @user = User.where(:email => email).first
    @user.confirm!
  end

  def get_quotes
    timestamp = Time.now.to_i*1000
    {"F"=>{"ipfSymbol"=>"F", "bidtime"=>timestamp, "bidexchangecode"=>"N", "bid"=>15.49, "bidsize"=>339, "asktime"=>timestamp, "askexchangecode"=>"K", "ask"=>15.5, "asksize"=>463, "time"=>timestamp, "exchangecode"=>"D", "price"=>15.4976, "size"=>300, "volume"=>9207502, "exchanges"=>"XNYS", "description"=>"Ford Motor Company Common Stock"}, "FB"=>{"ipfSymbol"=>"FB", "bidtime"=>timestamp, "bidexchangecode"=>"K", "bid"=>67.69, "bidsize"=>4, "asktime"=>timestamp, "askexchangecode"=>"P", "ask"=>67.7, "asksize"=>114, "time"=>timestamp, "exchangecode"=>"K", "price"=>67.69, "size"=>100, "volume"=>21880424, "exchanges"=>"XNAS", "description"=>"Facebook, Inc. - Class A Common Stock"}, "GM"=>{"ipfSymbol"=>"GM", "bidtime"=>timestamp, "bidexchangecode"=>"N", "bid"=>34.96, "bidsize"=>13, "asktime"=>timestamp, "askexchangecode"=>"K", "ask"=>34.97, "asksize"=>46, "time"=>timestamp, "exchangecode"=>"J", "price"=>34.97, "size"=>100, "volume"=>5831968, "exchanges"=>"XNYS", "description"=>"General Motors Company Common Stock"}, "GOOG"=>{"ipfSymbol"=>"GOOG", "bidtime"=>timestamp, "bidexchangecode"=>"Q", "bid"=>1200.11, "bidsize"=>1, "asktime"=>timestamp, "askexchangecode"=>"B", "ask"=>1201.13, "asksize"=>2, "time"=>timestamp, "exchangecode"=>"D", "price"=>1200.815, "size"=>200, "volume"=>808500, "exchanges"=>"XNAS", "description"=>"Google Inc. - Class A Common Stock"}, "JPM"=>{"ipfSymbol"=>"JPM", "bidtime"=>timestamp, "bidexchangecode"=>"Q", "bid"=>59.71, "bidsize"=>25, "asktime"=>timestamp, "askexchangecode"=>"Q", "ask"=>59.72, "asksize"=>18, "time"=>timestamp, "exchangecode"=>"D", "price"=>59.71, "size"=>200, "volume"=>11622979, "exchanges"=>"XNYS", "description"=>"JP Morgan Chase & Co. Common Stock"}, "MSFT"=>{"ipfSymbol"=>"MSFT", "bidtime"=>timestamp, "bidexchangecode"=>"Q", "bid"=>40.11, "bidsize"=>30, "asktime"=>timestamp, "askexchangecode"=>"Q", "ask"=>40.12, "asksize"=>93, "time"=>timestamp, "exchangecode"=>"D", "price"=>40.12, "size"=>85, "volume"=>19619303, "exchanges"=>"XNAS", "description"=>"Microsoft Corporation - Common Stock"}, "TSLA"=>{"ipfSymbol"=>"TSLA", "bidtime"=>timestamp, "bidexchangecode"=>"X", "bid"=>236.43, "bidsize"=>3, "asktime"=>timestamp, "askexchangecode"=>"J", "ask"=>236.7, "asksize"=>2, "time"=>timestamp, "exchangecode"=>"D", "price"=>236.43, "size"=>2, "volume"=>1805719, "exchanges"=>"XNAS", "description"=>"Tesla Motors, Inc. - Common Stock"}, "XOM"=>{"ipfSymbol"=>"XOM", "bidtime"=>timestamp, "bidexchangecode"=>"N", "bid"=>94.25, "bidsize"=>5, "asktime"=>timestamp, "askexchangecode"=>"P", "ask"=>94.26, "asksize"=>3, "time"=>timestamp, "exchangecode"=>"Q", "price"=>94.26, "size"=>100, "volume"=>3202861, "exchanges"=>"XNYS", "description"=>"Exxon Mobil Corporation Common Stock"}}
  end

  def run_rake
    StockResult.update_prices
    User.update_all_streaks
    User.update_all_rankings
    StockResult.create_next_day
  end
end