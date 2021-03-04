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
# Class product model
class Product < ApplicationRecord
  include AASM

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :category, class_name: 'Category', foreign_key: 'category_id'
  has_many :images, dependent: :delete_all

  aasm column: :state do
    state :unpublished, initial: true
    state :published, :archived

    event :publish do
      transitions from: [:archived, :unpublished], to: :published
    end

    event :unpublish do
      transitions from: [:archived, :published], to: :unpublished
    end

    event :archive do
      transitions from: [:published, :unpublished], to: :archived
    end
  end

  validates :name, presence: true
  validates :description, presence: true
  validates :quantity,  presence: true,
                        numericality: { only_integer: true,
                                        message: 'should be numeric' }
  validates :price, presence: true,
                    numericality: { only_integer: true,
                                    message: 'should be numeric' }

  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true

  scope :published, -> { where(state: 'published') }
end
