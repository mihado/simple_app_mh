require 'spec_helper'
# get the Matcher: have_error_message, have_success_message from utilities.rb

describe "User Pages" do

  subject { page }
  before { @regd_user = FactoryGirl.create(:user) }

  shared_examples_for "All User Pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(title)) }
  end

  describe "Profile Page" do
    before { visit user_path(@regd_user) }
    let(:heading) { @regd_user.name }
    let(:title) { @regd_user.name }

    it_should_behave_like "All User Pages"
  end

#$ SIGN UP STARTS
  describe "Sign Up Page" do
    before { visit signup_path }
    let(:heading) { 'Sign Up' }
    let(:title) { 'Sign Up' }

    it_should_behave_like "All User Pages"
  end

  describe "signup process" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        let(:heading) { 'Sign Up' }
        let(:title) { 'Sign Up' }
        before { click_button submit }

        it_should_behave_like "All User Pages"
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        @signup_user = FactoryGirl.build(:user)
        fill_valid_signup_info(@signup_user) #utilities.rb
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email(@signup_user.email) }
        let(:heading) { user.name }
        let(:title) { user.name }

        it_should_behave_like "All User Pages"
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out', href: signout_path) }
      end
    end
  end
#! SIGN UP ENDS

#$ EDIT STARTS
  describe "Edit Page" do
    before { visit edit_user_path(@regd_user) }
    let(:heading) { 'Update your profile' }
    let(:title) { 'Edit user' }

    it_should_behave_like "All User Pages"
    it { should have_link('change', href: 'http://gravatar.com/emails') }
  end

  describe "edit process" do
    before { visit edit_user_path(@regd_user) }

    describe "with invalid information" do
      before { click_button 'Save changes'}

      it { should have_error_message('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new-email@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: @regd_user.password
        fill_in "Confirm Password", with: @regd_user.password
        click_button 'Save changes'
      end

      let(:heading) { new_name }
      let(:title) { new_name }

      it_should_behave_like "All User Pages"
      it { should have_success_message('updated') }
      it { should have_link('Sign out', href: signout_path) }
      specify { @regd_user.reload.name.should == new_name }
      specify { @regd_user.reload.email.should == new_email }
    end
  end
#! EDIT ENDS

end
