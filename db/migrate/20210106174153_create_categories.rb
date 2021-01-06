class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :products, :categories
    drop_table :categories

    create_table :categories do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
end
