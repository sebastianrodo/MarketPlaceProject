FactoryBot.define do
  factory :product do
    name { 'PC MASTER RACE' }
    description { '4gb RAM, 2TB SOLID DISK' }
    quantity { 9 }
    price { 5000000 }
    state { 2 }
    association :user
    association :category, :random

    trait :with_specific_id do
      id { 1 }
    end

    trait :published do
      state { 0 }
    end
  end
end
