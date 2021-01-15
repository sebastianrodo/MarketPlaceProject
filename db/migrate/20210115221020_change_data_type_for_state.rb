class ChangeDataTypeForState < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :state, :integer, default: 2
  end
end
