require 'rails_helper'

RSpec.describe 'User Login page', :vcr do
  describe "As a Visitor" do
    describe "When I visit the user login page '/users/login'" do
      
      before do
        visit users_login_path
        @user = User.create!(username: 'my_username', password: 'my_password')
      end

      it "I see a place to enter my username and password" do
        expect(page).to have_field("username")
        expect(page).to have_field("password")
        expect(page).to have_button("Login")
      end

      it "If I enter a valid username and password, I am directed to my Dashboard page '/users/:id'" do
        fill_in "username", with: @user.username
        fill_in "password", with: @user.password
        click_button "Login"

        expect(current_path).to eq user_path(@user.id)
      end

      it "SAD PATH:  If I enter an invalid username or password, I stay on the same page and see a warning message that my credentials are invalid" do
        fill_in "username", with: "wrong_username"
        fill_in "password", with: @user.password
        click_button "Login"

        expect(current_path).to eq users_login_path
        expect(page).to have_content("Invalid credentials. Please try again.")

        fill_in "username", with: @user.username
        fill_in "password", with: "wrong_password"
        click_button "Login"

        expect(current_path).to eq users_login_path
        expect(page).to have_content("Invalid credentials. Please try again.")
      end
    end
  end
end