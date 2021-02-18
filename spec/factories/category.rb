FactoryBot.define do
  factory :category do
    name { "Technology" }
  end

  trait :with_specific_id do
    id { 1 }
  end

  trait :random do
    name { Faker::Commerce.unique.department }
  end
end
