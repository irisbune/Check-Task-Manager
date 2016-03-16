FactoryGirl.define do
  factory :task do
    task_description Faker::Hipster.sentence
    duedate Faker::Date.forward(30)
    status false
    association :project
  end
end
