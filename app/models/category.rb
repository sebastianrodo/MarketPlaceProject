# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Class category model
class Category < ApplicationRecord
  validates_uniqueness_of :name, allow_blank: true
  validates :name, presence: true
  has_many :products, dependent: :delete_all
end
