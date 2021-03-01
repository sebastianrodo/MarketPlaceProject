class AddUserIdToArticles < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :user, index: true
    add_foreign_key :products, :users
  end
end
