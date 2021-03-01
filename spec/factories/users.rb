FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '12345678' }
    first_name { 'Fake_name' }
    last_name  { 'Fake_last_name' }
    cellphone { Faker::PhoneNumber.cell_phone }

    trait :with_specific_id do
      id { 1 }
    end

    trait :another do
      first_name { 'Sebastian' }
    last_name  { 'Rodriguez' }
    end

    trait :admin do
      admin_role { true }
    end

    trait :with_current_password do
      current_password { '12345678' }
    end
  end
end
