class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories do |t|
      t.integer :product_variation_id, null: false
      t.integer :quantity
      t.datetime :last_updated

      t.timestamps
    end

    add_foreign_key :inventories, :product_variations
    add_index :inventories, :product_variation_id
  end
end
