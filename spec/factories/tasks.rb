FactoryGirl.define do
  factory :task do
    task_description Faker::Hipster.sentence
    duedate Faker::Date.forward(30)
    status false
    project

    trait :completed do
      status true
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
    end



  end
end
