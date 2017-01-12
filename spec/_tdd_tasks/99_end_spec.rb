class Students < StandardError
  
end

describe "Students", :type => :feature do

  before(:each) do
    init_message
  end
  
  it "should be happy they completed the introductory exercise and fill out a questionaire" do
    test_run do
      Given "an eager student or two"
    
      When "they have completed the Ruby on Rails exercise"
      
      Then "each student should, on their own,\n" + 
        "- fill out [this questionaire](https://docs.google.com/forms/d/e/1FAIpQLScEOXy0wrk9Y2DDx5QT0Nz4x5l9up9TKdfcbylMhssPh0fqNA/viewform?c=0&w=1),\n" + 
        "- use the remaining time to have a look at the [application stub](https://github.com/hpi-swt2/workshop-portal),\n" + 
        "- or look at some other Rails tutorials, such as [Rails for Zombies](http://railsforzombies.com/)."
      
      raise Students, "'Yeah, we can't wait for the project to start!'"
    end
  end
end