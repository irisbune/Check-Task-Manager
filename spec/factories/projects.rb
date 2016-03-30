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

    trait :in_same_month do
      start_date Faker::Date.between(Date.new(2020,04,01), Date.new(2020,04,30))
    end

    trait :in_past do
      start_date Date.yesterday
    end

    factory :invalid_project do
      name nil
      start_date nil
    end

    trait :with_tasks do

      transient do
        number_of_tasks 4
      end

      after(:create) do |project, evaluator|
        create_list(:task, evaluator.number_of_tasks, project: project)
      end

    end
  end

end
