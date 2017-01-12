FactoryGirl.define do
  begin
    factory :paper_tdd, :class => Paper do
      title "COMPUTING MACHINERY AND INTELLIGENCE"
      venue "Mind 49: 433-460"
      year 1950
      #authors {build_list :author, 1}
    end
    factory :paper_author_tdd, :class => Paper do
      title "COMPUTING MACHINERY AND INTELLIGENCE"
      venue "Mind 49: 433-460"
      year 1950
      authors {build_list :author, 1}
    end
  rescue; end
end