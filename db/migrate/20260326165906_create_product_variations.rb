class CreateProductVariations < ActiveRecord::Migration[7.]
  def change
    create_table :product_variations, id: :uuid do |t|
      t.uuid :product_id, null: false
      t.string :variation_name, null: false
      t.string :variation_value, null: false

      t.timestamps
    end

    add_foreign_key :product_variations, :products
    add_index :product_variations, :product_id
  end
end