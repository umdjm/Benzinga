require 'spec_helper'

describe "StockPicks" do
  describe "GET /users/sign_up" do
    it "creates a user" do
      visit new_user_registration_path
      fill_in "Email", :with => "test@test.com"
      fill_in "Name", :with => "Sample Name"
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "password"
      click_button "Sign up"
    end
  end
end
