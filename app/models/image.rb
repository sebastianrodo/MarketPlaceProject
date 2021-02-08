# frozen_string_literal: true

# Class image model
class Image < ApplicationRecord
  belongs_to :product

  has_attached_file :image, styles: { medium: '1280x720', thumb: '800x600' }
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
end
