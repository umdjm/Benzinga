require 'spec_helper'

describe "StockPicks" do

  describe "Signup" do
    it "creates user and displays stocks", :js => true do
      sign_up
      User.count.should == 1
      page.should have_content "Logout"
      page.should_not have_content "Sign Up"
      page.should_not have_content "Login"
      page.should have_content "Welcome To Up or Dow!"
      page.should have_content "How to Play"
    end
  end

  describe "Signin" do
    it "logs the user in", :js => true do
      sign_up
      click_link "Logout"
      page.should have_content "Sign Up"
      page.should have_content "Login"
      page.should_not have_content "Logout"
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => "password"
      click_button "Log in"
      page.should have_content "Logout"
      page.should_not have_content "Sign Up"
      page.should_not have_content "Login"
    end
  end

  describe "Home Page" do
    it "Display Leaderboard", :js => true do
      sign_up
      page.should have_content "Leaderboard"
      page.should have_content Time.now.in_time_zone("America/New_York").strftime("%A, %B %-d")
    end

    it "display current options", :js => true do
      StockResult.create_next_day
      sign_up
      page.should have_selector('.stock-options tr', :minimum => 3)
    end

    it "show pick details", :js => true do
      StockResult.create_next_day
      sign_up
      click_link "UP"
      page.should have_selector('.stock-options tr td .btn-group .btn-info')
      page.should have_content('Current Pick')
    end
  end

  describe "Pick History" do
    it "Displays Previous Picks", :js => true do
      sign_up
      new_time = Time.parse("Tue, 01 Apr 2014 21:10:00 EDT -04:00")
      3.times do
        Timecop.freeze(new_time)
        run_rake
        sr = StockResult.last
        stock_pick = @user.stock_picks.build
        stock_pick.assigned_price = sr.price - 1
        stock_pick.stock_result_id = sr.id
        stock_pick.prediction = "up"
        stock_pick.save
        new_time = new_time + 1.day
      end
      Timecop.freeze(new_time)
      run_rake
      click_link "Pick History"
      page.all(".historical-stock-pick").count.should eql(3)
    end


    it "Displays Leaderboard", :js => true do
      sign_up
      new_time = Time.parse("Tue, 01 Apr 2014 21:10:00 EDT -04:00")
      3.times do
        Timecop.travel(new_time)
        run_rake
        sr = StockResult.last
        stock_pick = @user.stock_picks.build
        stock_pick.assigned_price = sr.price - 1
        stock_pick.stock_result_id = sr.id
        stock_pick.prediction = "up"
        stock_pick.save
        new_time = new_time + 1.day
      end
      click_link "Logout"
      sign_up
      5.times do
        Timecop.travel(new_time)
        run_rake
        sr = StockResult.last
        stock_pick = @user.stock_picks.build
        stock_pick.assigned_price = sr.price - 1
        stock_pick.stock_result_id = sr.id
        stock_pick.prediction = "up"
        stock_pick.save
        new_time = new_time + 1.day
      end
      Timecop.travel(new_time)
      run_rake
      click_link "Pick History"
      page.all(".leaders > tr").count.should eql(2)
      page.should have_selector(".leaders .user-record", :text => "5-0")
      page.should have_selector(".leaders .max-streak", :text => "5")
      page.should have_selector(".leaders .current-streak", :text => "5")
      page.should have_selector(".leaders .user-rank", :text => "1")
      page.should have_selector(".leaders .user-record", :text => "3-0")
      page.should have_selector(".leaders .max-streak", :text => "3")
      page.should have_selector(".leaders .current-streak", :text => "3")
      page.should have_selector(".leaders .user-rank", :text => "2")
    end
  end

  describe "Stock Results" do
    it "Skips Weekends", :js => true do
      new_time = Time.parse("Tue, 01 Apr 2014 21:10:00 EDT -04:00")
      5.times do
        Timecop.freeze(new_time)
        run_rake
        new_time = new_time + 1.day
      end
      Timecop.freeze(new_time)
      run_rake
      StockResult.select("result_date").group(:result_date).all.count.should eq(4)
      StockResult.count.should eq(8*4)
    end

    it "Skips Holidays", :js => true do
      new_time = Time.parse("2014-12-23 21:10:00 EDT -04:00")
      5.times do
        Timecop.freeze(new_time)
        run_rake
        new_time = new_time + 1.day
      end
      Timecop.freeze(new_time)
      run_rake
      StockResult.select("result_date").group(:result_date).all.count.should eq(2)
      StockResult.count.should eq(8*2)
    end

    it "Closes After Last Call", :js => true   do
      new_time = Time.parse("Tue, 01 Apr 2014 21:10:00 EDT -04:00")
      StockResult.count.should eq(0)
      18.times do
        Timecop.freeze(new_time)
        run_rake
        StockResult.where(:closing_price => nil).count.should eq(8)
        new_time = new_time + 1.hour
      end
      new_time = new_time + 1.hour
      Timecop.freeze(new_time)
      StockResult.update_prices
      StockResult.where(:closing_price => nil).count.should eq(0)
    end
  end

  describe "Scheduler" do
    it "Updates Streaks", :js => true do
      sign_up
      new_time = Time.parse("Tue, 01 Apr 2014 21:10:00 EDT -04:00")
      3.times do
        Timecop.freeze(new_time)
        run_rake
        sr = StockResult.last
        stock_pick = @user.stock_picks.build
        stock_pick.assigned_price = sr.price - 1
        stock_pick.stock_result_id = sr.id
        stock_pick.prediction = "up"
        stock_pick.save
        new_time = new_time + 1.day
      end
      Timecop.freeze(new_time)
      run_rake
      StockPick.count.should eq(3)
      @user.reload
      @user.max_streak.should eq(3)
      @user.current_streak.should eq(3)
      @user.correct_count.should eq(3)
      @user.incorrect_count.should eq(0)
    end


    it "Prevents Duplicate Stocks", :js => true  do
      new_time = Time.parse("Tue, 01 Apr 2014 21:10:00 EDT -04:00")
      StockResult.count.should eq(0)
      18.times do
        Timecop.freeze(new_time)
        run_rake
        StockResult.count.should eq(8)
        new_time = new_time + 1.hour
      end
      24.times do
        new_time = new_time + 1.hour
        Timecop.freeze(new_time)
        run_rake
        StockResult.count.should eq(16)
      end

    end
  end

  describe "Emailer" do
    it "Sends Morning Email", :js => true

    it "Sends Nightly Recap", :js => true
  end
end
