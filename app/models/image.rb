# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id                 :bigint           not null, primary key
#  image_content_type :string
#  image_file_name    :string
#  image_file_size    :bigint
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  product_id         :bigint           not null
#
# Indexes
#
#  index_images_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
# Class image model
class Image < ApplicationRecord
  belongs_to :product

  has_attached_file :image, styles: { medium: '1280x720', thumb: '800x600' }
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
end
