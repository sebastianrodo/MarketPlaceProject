# frozen_string_literal: true

class CreateTableProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string  :name,        null: false
      t.text    :description, null: false
      t.integer :quantity,    null: false
      t.integer :price,       null: false

      t.timestamps
    end
  end
end
