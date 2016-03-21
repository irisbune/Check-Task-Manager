FactoryGirl.define do
  factory :project do
    name Faker::Hipster.sentence
    description Faker::Hipster.sentence
    start_date Faker::Date.forward(30)

    trait :open do
      status "open"
    end

    trait :done do
      status "done"
    end

    trait :canceled do
      status "canceled"
    end

    factory :invalid_project do
      name nil
      start_date nil
    end

    factory :project_with_tasks do
      after(:create) do |project|
        create_list(:task, 4, project: project)
      end
    end
  end

end
