require 'rails_helper'

describe "New author page", :type => :feature do
  
  before(:each) do
    init_message
  end 
  
  it "should render" do
    test_run do
      When "a user visits the new author page"
      Then "the page should render"
	  
	  Comment "You need to create an `AuthorsController` with a `new` action and set-up the appropriate routes. See the [Rails guide](http://guides.rubyonrails.org/getting_started.html#getting-up-and-running) for help."
	  
      visit new_author_path
    end
  end

  it "should have text input for first name, last name, and homepage" do
    test_run do
      When "a user visits the new author page"
      visit new_author_path
      
      Then "it should have a field 'First name'"
      expect(page).to have_field('First name')
      
      Then "it should have a field 'Last name'"
      expect(page).to have_field('Last name')
      
      Then "it should have a field 'Homepage'"
      expect(page).to have_field('Homepage')
    end
  end
  
  it "should have a submit button" do
    test_run do
      When "a user visits the new author page"
      visit new_author_path
      Then "it should have a button to submit the form"
      expect(page).to have_css('input[type="submit"]')
    end
  end
end

describe "Author", :type => :model do
  
  before(:each) do
    init_message
  end 
  
  it "should have first name, last name, and homepage" do
    test_run do
      When "an author is created with first name 'Alan', last name 'Turing', and homepage 'http://wikipedia.org/Alan_Turing'"
      
      Then "an instance of Author should be created"
      alan = Author.new(first_name: 'Alan', last_name: 'Turing', homepage: 'http://wikipedia.org/Alan_Turing')
      
      Then "first name should be 'Alan'"
      expect(alan.first_name).to eq('Alan')
      
      Then "last name should be 'Turing'"
      expect(alan.last_name).to eq('Turing')
      
      Then "homepage should be 'http://wikipedia.org/Alan_Turing'"
      expect(alan.homepage).to eq('http://wikipedia.org/Alan_Turing')
    end
  end
  
  it "#name should return the full name" do
    test_run do
      Given "an author `a` with first name 'Alan' and last name 'Turing'"
      alan = FactoryGirl.create :author_tdd
      
      Then "`a.name` should be 'Alan Turing'"
      expect(alan.name).to eq('Alan Turing')
    end
  end
end
  
describe "New author page", :type => :feature do
  
  before(:each) do
    init_message
  end 
  
  it "should save the author" do
    test_run do
      When "a user visits the new author page"
      visit new_author_path
      
      And "fills in 'Alan', 'Turing', and 'http://wikipedia.org/Alan_Turing', respectively"
      fill_author('Alan', 'Turing', 'http://wikipedia.org/Alan_Turing')
      
      And "submits the form"
      expect(page).to have_css('input[type="submit"]')
      begin
        submit_form
      rescue; end
      
      Then "Alan Turing should be found in the database"
      alan = Author.find_by!(:last_name => 'Turing')
      expect(alan).to_not be_nil
      
      Then "Alan Turing's first name should be 'Alan'"
      expect(alan.first_name).to eq("Alan")
    end
  end
end

describe "Author page", :type => :feature do
  
  before(:each) do
    init_message

    Given "an author named 'Alan Turing'"
    @alan = FactoryGirl.create :author_tdd
  end
  
  it "should render" do
    test_run do
      When "a user visits the author's page"
      Then "the page should render"
      visit author_path(@alan)
    end
  end
  
  it "should display author details" do
    test_run do
      When "a user visits the author's page"
      visit author_path(@alan)
      
      Then "it should show the author's first name"
      expect(page).to have_text(/First name: #{@alan.first_name}/i)
      
      Then "it should show the author's last name"
      expect(page).to have_text(/Last name: #{@alan.last_name}/i)
      
      Then "it should show the author's homepage"
      expect(page).to have_text(/Homepage: #{@alan.homepage}/i)
    end
  end
end

describe "Author index page", :type => :feature do

  before(:each) do
    init_message
  end
  
  it "should render" do
    test_run do
      When "a user visits the authors index page"
      Then "the page should render"
      visit authors_path
    end
  end
  
  it "should list name and homepage of all authors" do
    test_run do
      Given "an author named 'Alan Turing'"
      @alan = FactoryGirl.create :author_tdd
    
      When "a user visits the authors index page"
      visit authors_path
      
      Then "it should show Turing's name"
      expect(page).to have_text(@alan.name)
      
      Then "it should show Turing's homepage"
      expect(page).to have_text(@alan.homepage)
    end
  end
  
  it "should list first and last name in one column" do
    test_run do
      When "a user visits the authors index page"
      visit authors_path
      
      Then "it should have a column titled 'Name'"
      expect(page).to have_css("th", :text => 'Name')
      
      Then "it should have a column titled 'Homepage'"
      expect(page).to have_css("th", :text => 'Homepage')
    end
  end
  
  it "should link to the new author page" do
    test_run do
      When "users visits the authors index page"
      visit authors_path
      
      Then "it has a link 'Add author'"
      expect(page).to have_css("a", :text => 'Add author')
      
      When "click 'Add author'"
      click_link 'Add author'
      
      Then "they should see the new author page"
      expect(current_path).to eq(new_author_path)
    end
  end
  
  it "should link to author page" do
    test_run do
      Given "an author named 'Alan Turing'"
      @alan = FactoryGirl.create :author_tdd
    
      When "users visits the authors index page"
      visit authors_path
      
      Then "it should link to the author page"
      expect(page).to have_css("a", :text => 'Show')
      
      When "click 'Show'"
      click_link 'Show'
      
      Then "they should see the author's page"
      expect(current_path).to eq(author_path(@alan))
    end
  end
end

describe "Author", :type => :model do
  
  before(:each) do
    init_message
  end

  it "should not validate without last name" do
    test_run do
      When "creating an author without last name"
      a = Author.new(first_name: 'Alan', homepage: 'http://example.com')

      Then "validation should fail"
      expect(a).to_not be_valid
    end
  end

  it "should not validate with empty last name" do
    test_run do
      When "creating an author with empty last name"
      a = Author.new(first_name: 'Alan', last_name: '', homepage: 'http://example.com')

      Then "validation should fail"
      expect(a).to_not be_valid
    end
  end
end

describe "New author page", :type => :feature do
  
  before(:each) do
    init_message
  end 
  
  it "should show validation errors" do
    test_run do
      Given "users visit the new author page"
      visit new_author_path

      And "fill in only first name and homepage"
      fill_in "author_first_name", :with => 'Alan'
      fill_in "author_first_name", :with => 'http://example.com'

      When "they click submit"
      submit_form

      Then "the page should report that last name can't be blank"
      expect(page).to have_content("Last name can't be blank")
    end
  end
end


describe "Edit author page", :type => :feature do
  
  before(:each) do
    init_message
    
    Given "an author named 'Alan Turing'"
    @alan = FactoryGirl.create :author_tdd
  end
  
  it "should render" do
    test_run do
      When "a user visits the author's edit page"
      Then "the page should render"
      visit edit_author_path(@alan)
    end
  end
  
  it "should save changes" do
    test_run do
      When "a user visits the author's edit page"
      visit edit_author_path(@alan)
      
      And "changes first name to 'Alan Mathison'"
      fill_in "author_first_name", :with => 'Alan Mathison'
      
      And "clicks submit"
      submit_form
      
      Then "Turing's first name should be updated"
      expect(@alan.reload.first_name).to eq('Alan Mathison')
    end
  end
end

describe "Author index page", :type => :feature do

  before(:each) do
    init_message
  end
  
  it "should link to edit author page" do
    test_run do
      Given "an author named 'Alan Turing'"
      @alan = FactoryGirl.create :author_tdd
    
      When "users visit the authors index page"
      visit authors_path
      
      Then "it should link to the author's edit page"
      expect(page).to have_css("a", :text => 'Edit')
      
      When "click 'Edit'"
      click_link 'Edit'
      
      Then "they should see the author's edit page"
      expect(current_path).to eq(edit_author_path(@alan))
    end
  end
  
  it "should have a link to delete an author" do
    test_run do
      Given "an author named 'Alan Turing'"
      @alan = FactoryGirl.create :author_tdd
    
      When "users visit the authors index page"
      visit authors_path
      
      Then "it should have a destroy link"
      expect(page).to have_css("a", :text => 'Destroy')
      
      When "click 'Destroy'"
      click_link 'Destroy'
      
      Then "the author should be deleted"
      a = Author.find_by(id: @alan.id)
      expect(a).to be_nil
    end
  end
end