class ChangeFkImageBelongToProductToOnDeleteCascade < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :images, :products
    add_foreign_key :images, :products, on_delete: :cascade
  end
end
