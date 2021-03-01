# frozen_string_literal: true

# Class product model
class Product < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :category, class_name: 'Category', foreign_key: 'category_id'
  has_many :images, dependent: :delete_all

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

  enum state: %i[published archived unpublished]
end
