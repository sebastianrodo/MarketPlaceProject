class Product < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :category, class_name: 'Category', foreign_key: 'category_id'

  scope :published, -> { where(state: "published") }

  enum state: [:published, :archived, :unpublished]

  def category=(value)
    @category = value
  end
end
