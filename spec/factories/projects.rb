FactoryGirl.define do
  factory :project do
    name Faker::Hipster.sentence
    description Faker::Hipster.sentences
    status "open"
    start_date Faker::Date.forward(30)

    factory :invalid_project do
      name nil
    end
  end

end
