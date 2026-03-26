class CreateProductVariations < ActiveRecord::Migration[7.2]
  def change
    create_table :product_variations do |t|
      t.references :product, null: false, foreign_key: true
      t.string :variation_name
      t.string :variation_value
      t.string :sku

      t.timestamps
    end
  end
end
