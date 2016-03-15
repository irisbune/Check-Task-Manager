FactoryGirl.define do
  factory :project do
    name "My project"
    description "A huge project"
    status "open"
    start_date Date.today
  end
end
