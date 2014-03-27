require 'spec_helper'

describe "StockPicks" do

  describe "Visit Home Page" do
    it "Display Leaderboard and Current Pick Options", :js => true do
      sign_up
      page.should have_content "Leaderboard"
      page.should have_content Time.now.in_time_zone("America/New_York").strftime("%A, %B %-d")
    end

    it "display current options", :js => true do
      StockResult.create_next_day
      sign_up
      page.should have_selector('.stock-options tr', :minimum => 3)
      pause
    end
  end
end
