# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  name        :string           not null
#  price       :integer          not null
#  quantity    :integer          not null
#  state       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  user_id     :bigint
#
# Indexes
#
#  index_products_on_category_id  (category_id)
#  index_products_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :product do
    name { 'PC MASTER RACE' }
    description { '4gb RAM, 2TB SOLID DISK' }
    quantity { 9 }
    price { 5_000_000 }
    state { 'unpublished' }
    association :user
    association :category, :random

    trait :with_specific_id do
      id { 1 }
    end

    trait :published do
      state { 'published' }
    end
  end
end
