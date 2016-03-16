FactoryGirl.define do
  factory :task do
    task_description "An important todo"
    duedate Date.tomorrow
    status false
    association :project
  end
end
