class ChangeCellphoneToNullTrueInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :cellphone, :bigint, limit: 15, :null => true
  end
end
