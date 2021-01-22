class ChangeCellphoneUserIntToString < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :cellphone, :string, :null => true
  end
end
