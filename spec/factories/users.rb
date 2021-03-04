# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  admin_role             :boolean          default(FALSE)
#  cellphone              :string(15)
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  user_role              :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '12345678' }
    first_name { 'Fake_name' }
    last_name  { 'Fake_last_name' }
    cellphone { Faker::PhoneNumber.unique.cell_phone }

    trait :with_specific_id do
      id { 1 }
    end

    trait :another do
      first_name { 'Sebastian' }
      last_name { 'Rodriguez' }
    end

    trait :admin do
      admin_role { true }
    end

    trait :with_current_password do
      current_password { '12345678' }
    end

    trait :custom_email do
      email { 'sarodriguez5244@misena.edu.co' }
    end
  end
end
