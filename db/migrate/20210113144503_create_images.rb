# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.belongs_to :product, null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
