# frozen_string_literal: true

class AddStateToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :state, :string
  end
end
