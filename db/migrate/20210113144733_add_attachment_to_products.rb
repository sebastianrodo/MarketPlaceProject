class AddAttachmentToProducts < ActiveRecord::Migration[6.0]
  def change
    add_attachment :images, :image
  end
end
