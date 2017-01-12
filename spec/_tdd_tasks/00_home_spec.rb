require 'rails_helper'

describe "Front page", :type => :feature do
  
  before(:each) do
    init_message
  end
  
  it "should show application title" do
    test_run do
      When("a user visits the root path")
      visit root_path
      
      Then("the page should display 'Paper Management System'")
      expect(page).to have_text(/Paper ManaGement System/i)
    end
  end
end