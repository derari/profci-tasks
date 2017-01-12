require 'rails_helper'

describe "New paper page", :type => :feature do
  
  before(:each) do
    init_message
  end 

  it "should have text input for title, venue, and year" do
    test_run do
      When "a user visits the new author page"

      Then "the page should render"
      visit new_paper_path
      
      Then "it should have a field 'Title'"
      expect(page).to have_field('Title')
      
      Then "it should have a field 'Venue'"
      expect(page).to have_field('Venue')
      
      Then "it should have a field 'Year'"
      expect(page).to have_field('Year')
    end
  end
  
  it "should have a submit button" do
    test_run do
      When "a user visits the new paper page"
      visit new_paper_path
      Then "it should have a button to submit the form"
      expect(page).to have_css('input[type="submit"]')
    end
  end
end

describe "Paper", :type => :model do
  
  before(:each) do
    init_message
  end 
  
  it "should have title, venue, and year" do
    test_run do
      When "a paper is created with title 'COMPUTING MACHINERY AND INTELLIGENCE',"
      And "venue 'Mind 49: 433-460', and year 1950"
      
      Then "an instance of Paper should be created"
      paper = Paper.new(title: 'COMPUTING MACHINERY AND INTELLIGENCE', venue: 'Mind 49: 433-460', year: 1950)
      
      Then "title should be 'COMPUTING MACHINERY AND INTELLIGENCE'"
      expect(paper.title).to eq('COMPUTING MACHINERY AND INTELLIGENCE')
      
      Then "venue should be 'Mind 49: 433-460'"
      expect(paper.venue).to eq('Mind 49: 433-460')
      
      Then "year should be 1950"
      expect(paper.year).to eq(1950)
    end
  end
  
  it "should not validate without title" do
    test_run do
      When "creating a paper without title"
      p = Paper.new(venue: 'Mind 49: 433-460', year: 1950)

      Then "validation should fail"
      expect(p).to_not be_valid
    end
  end

  it "should not validate with empty title" do
    test_run do
      When "creating a paper with empty title"
      p = Paper.new(title: '', venue: 'Mind 49: 433-460', year: 1950)

      Then "validation should fail"
      expect(p).to_not be_valid
    end
  end
  
  it "should not validate without venue" do
    test_run do
      When "creating a paper without venue"
      p = Paper.new(title: 'COMPUTING MACHINERY AND INTELLIGENCE', year: 1950)

      Then "validation should fail"
      expect(p).to_not be_valid
    end
  end

  it "should not validate with empty venue" do
    test_run do
      When "creating a paper with empty venue"
      p = Paper.new(title: 'COMPUTING MACHINERY AND INTELLIGENCE', venue: '', year: 1950)

      Then "validation should fail"
      expect(p).to_not be_valid
    end
  end
  
  it "should not validate without year" do
    test_run do
      When "creating a paper without year"
      p = Paper.new(title: 'COMPUTING MACHINERY AND INTELLIGENCE', venue: 'Mind 49: 433-460')

      Then "validation should fail"
      expect(p).to_not be_valid
    end
  end

  it "should not validate with non-integer year" do
    test_run do
      When "creating a paper with year 'nineteen-fifty'"
      p = Paper.new(title: 'COMPUTING MACHINERY AND INTELLIGENCE', venue: 'Mind 49: 433-460', year: 'nineteen-fifty')

      Then "validation should fail"
      expect(p).to_not be_valid
    end
  end
end
  
describe "New paper page", :type => :feature do
  
  before(:each) do
    init_message
  end 
  
  it "should save the paper" do
    test_run do
      When "a user visits the new paper page"
      visit new_paper_path
      
      And "fills in 'COMPUTING MACHINERY AND INTELLIGENCE', 'Mind 49: 433-460', and 1950, respectively"
      fill_paper('COMPUTING MACHINERY AND INTELLIGENCE', 'Mind 49: 433-460', 1950)
      
      And "submits the form"
      expect(page).to have_css('input[type="submit"]')
      begin
        submit_form
      rescue; end
      
      Then "the paper should be found in the database"
      paper = Paper.find_by!(:title => 'COMPUTING MACHINERY AND INTELLIGENCE')
      expect(paper).to_not be_nil
      
      Then "the paper's venue should be 'Mind 49: 433-460'"
      expect(paper.venue).to eq("Mind 49: 433-460")
    end
  end
end

describe "Paper page", :type => :feature do
  
  before(:each) do
    init_message

    @paper = FactoryGirl.create :paper_tdd
    Given "a paper entitled '#{@paper.title}'"
  end
  
  it "should display paper details" do
    test_run do
      When "a user visits the paper's page"

      Then "the page should render"
      visit paper_path(@paper)
      
      Then "it should show the paper's title"
      expect(page).to have_text(/Title: #{@paper.title}/i)
      
      Then "it should show the paper's venue"
      expect(page).to have_text(/Venue: #{@paper.venue}/i)
      
      Then "it should show the paper's year"
      expect(page).to have_text(/Year: #{@paper.year}/i)
    end
  end
end

describe "Paper index page", :type => :feature do

  before(:each) do
    init_message
  end
  
  it "should list title, venue, and year of all papers" do
    test_run do
      @paper = FactoryGirl.create :paper_tdd
      Given "a paper entitled '#{@paper.title}'"
    
      When "a user visits the papers index page"
      
      Then "the page should render"
      visit papers_path
      
      Then "it should show the paper's title"
      expect(page).to have_text(@paper.title)
      
      Then "it should show the paper's venue"
      expect(page).to have_text(@paper.venue)
      
      Then "it should show the paper's year"
      expect(page).to have_text(@paper.year)
    end
  end
  
  it "should link to the new paper page" do
    test_run do
      When "users visits the papers index page"
      visit papers_path
      
      Then "it has a link 'Add paper'"
      expect(page).to have_css("a", :text => 'Add paper')
      
      When "click 'Add paper'"
      click_link 'Add paper'
      
      Then "they should see the new paper page"
      expect(current_path).to eq(new_paper_path)
    end
  end
  
  it "should link to paper page" do
    test_run do
      @paper = FactoryGirl.create :paper_tdd
      Given "a paper"
    
      When "users visits the papers index page"
      visit papers_path
      
      Then "it should link to the paper page"
      expect(page).to have_css("a", :text => 'Show')
      
      When "click 'Show'"
      click_link 'Show'
      
      Then "they should see the paper's page"
      expect(current_path).to eq(paper_path(@paper))
    end
  end
end

describe "New paper page", :type => :feature do
  
  before(:each) do
    init_message
  end 
  
  it "should show validation errors" do
    test_run do
      Given "users visit the new paper page"
      visit new_paper_path

      And "fill in only venue and year"
      fill_paper('', 'Mind 49: 433-460', 1950)

      When "they click submit"
      submit_form

      Then "the page should report that title can't be blank"
      expect(page).to have_content("Title can't be blank")
    end
  end
end


describe "Edit paper page", :type => :feature do
  
  before(:each) do
    init_message
    
    @paper = FactoryGirl.create :paper_tdd
    Given "a paper"
  end
  
  it "should save changes" do
    test_run do
      When "a user visits the paper's edit page"
      
      Then "the page should render"
      visit edit_paper_path(@paper)
      
      When "changes venue to 'Mind 49'"
      fill_in "paper_venue", :with => 'Mind 49'
      
      And "clicks submit"
      submit_form
      
      Then "the paper's venue should be updated"
      expect(@paper.reload.venue).to eq('Mind 49')
    end
  end
end

describe "Paper index page", :type => :feature do

  before(:each) do
    init_message
  end
  
  it "should link to edit paper page" do
    test_run do
      @paper = FactoryGirl.create :paper_tdd
      Given "a paper"
    
      When "users visit the papers index page"
      visit papers_path
      
      Then "it should link to the paper's edit page"
      expect(page).to have_css("a", :text => 'Edit')
      
      When "click 'Edit'"
      click_link 'Edit'
      
      Then "they should see the paper's edit page"
      expect(current_path).to eq(edit_paper_path(@paper))
    end
  end
  
  it "should have a link to delete a paper" do
    test_run do
      @paper = FactoryGirl.create :paper_tdd
      Given "a paper"
    
      When "users visit the papers index page"
      visit papers_path
      
      Then "it should have a destroy link"
      expect(page).to have_css("a", :text => 'Destroy')
      
      When "click 'Destroy'"
      click_link 'Destroy'
      
      Then "the paper should be deleted"
      a = Paper.find_by(id: @paper.id)
      expect(a).to be_nil
    end
  end
end