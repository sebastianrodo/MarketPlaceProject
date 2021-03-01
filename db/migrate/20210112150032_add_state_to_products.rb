class AddStateToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :state, :integer, default: 0
  end
end
