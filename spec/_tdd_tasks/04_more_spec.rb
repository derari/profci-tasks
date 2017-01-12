describe "Paper index page", :type => :feature do

  before(:each) do
    init_message
  end

  it "should allow to filter by year" do
    test_run do
      paper1950 = FactoryGirl.create :paper_tdd
      paper1968 = FactoryGirl.create :paper_tdd, title: 'GO TO statement considered harmful', venue: 'Communications of the ACM', year: 1968
      Given "a paper published in 1950"
      And "a paper published in 1968"

      When "users visit the papers index page with url parameter `year=1950`"
      visit papers_path(year: 1950)

      Comment "You can use scopes [[1]](http://guides.rubyonrails.org/active_record_querying.html#scopes) to implement this behavior."

      Then "it should show the paper written in 1950"
      expect(page).to have_text(paper1950.title)

      Then "it should not show the paper published in 1968"
      expect(page).to_not have_text(paper1968.title)
    end
  end
end