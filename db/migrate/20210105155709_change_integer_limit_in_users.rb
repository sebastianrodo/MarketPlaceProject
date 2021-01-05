class ChangeIntegerLimitInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :cellphone, :bigint, limit: 15
  end
end
