class Product < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :category, class_name: 'Category', foreign_key: 'category_id'
  has_many :images, dependent: :delete_all
  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true

  scope :published, -> { where(state: "published") }

  enum state: [:published, :archived, :unpublished]

  def category=(value)
    @category = value
  end
end
