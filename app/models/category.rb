# frozen_string_literal: true

# Class category model
class Category < ApplicationRecord
  validates_uniqueness_of :name, allow_blank: true, allow_nil: true
  validates :name, presence: true
  has_many :products, dependent: :delete_all
end
