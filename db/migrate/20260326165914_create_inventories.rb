class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories, id: :uuid do |t|
      t.uuid :product_variation_id, null: false
      t.integer :quantity, null: false, default: 0
      t.datetime :last_updated

      t.timestamps
    end

    add_foreign_key :inventories, :product_variations
    add_index :inventories, :product_variation_id
  end
end