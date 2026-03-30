class CreateProductVariations < ActiveRecord::Migration[7.2]
  def change
    create_table :product_variations do |t|
      t.integer :product_id, null: false
      t.string :variation_name
      t.string :variation_value
      t.string :sku

      t.timestamps
    end

    add_foreign_key :product_variations, :products
    add_index :product_variations, :product_id
  end
end