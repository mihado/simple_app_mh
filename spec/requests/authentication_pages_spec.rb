require 'spec_helper'
# get the Matcher: have_error_message, have_success_message from utilities.rb

describe "Authentication" do

  subject { page }

  describe "Signin Page" do
    before { visit signin_path }

    it { should have_selector('h1', text: 'Sign In') }
    it { should have_selector('title', text: 'Sign In') }
  end

  describe "signin process" do
    before { visit signin_path }
    let(:submit) { "Sign in" }

    describe "with invalid information" do
      before { click_button submit }

      it { should have_selector('title', text: 'Sign In') }
      it { should have_error_message('Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }

        it { should_not have_error_message('Invalid') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { fill_valid_info(user) } #get this from utilities.rb

      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "after sign out" do
        before { click_link "Sign out" }
        it { should have_link('Sign in', href: signin_path) }
        it { should_not have_link('Sign out', href: signout_path) }
      end
    end
  end
end