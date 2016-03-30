FactoryGirl.define do
  factory :task do
    task_description Faker::Hipster.sentence
    duedate Faker::Date.forward(30)
    association :project

    trait :completed do
      status true
    end

    trait :open do
      status false
    end

    trait :in_past do
      duedate Date.yesterday
    end

    trait :tomorrow do
      duedate Date.tomorrow
    end

    factory :invalid_task do
      task_description nil
      duedate nil
      status nil
      project_id nil
    end



  end
end
