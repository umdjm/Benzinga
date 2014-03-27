require 'spec_helper'

describe "Users" do
  describe "Signup" do
    it "creates a user", :js => true do
      sign_up
      User.count.should == 1
    end

    it "logs the user in", :js => true do
      sign_up
      page.should have_content "Logout"
      page.should_not have_content "Sign Up"
      page.should_not have_content "Login"
    end

    it "displays welcome message", :js => true do
      sign_up
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
      click_button "Sign in"
      page.should have_content "Logout"
      page.should_not have_content "Sign Up"
      page.should_not have_content "Login"
    end
  end
end
