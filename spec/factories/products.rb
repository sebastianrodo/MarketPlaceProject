FactoryBot.define do
  factory :product do
    name { 'PC MASTER RACE' }
    description { '4gb RAM, 2TB SOLID DISK' }
    quantity { 9 }
    price { 5000000 }
    state { 0 }
    association :user
    association :category
  end
end
