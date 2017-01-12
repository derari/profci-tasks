FactoryGirl.define do
  begin
    factory :author_tdd, :class => Author do
      first_name "Alan"
      last_name "Turing"
      homepage "http://wikipedia.de/Alan_Turing"
    end
  rescue; end
end