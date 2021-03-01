# frozen_string_literal: true

# Class category model
class Category < ApplicationRecord
  has_many :products, dependent: :delete_all
end
