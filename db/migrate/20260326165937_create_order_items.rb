class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.integer :order_id, null: false
      t.integer :product_variation_id, null: false
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :total_price

      t.timestamps
    end

    add_foreign_key :order_items, :orders
    add_foreign_key :order_items, :product_variations

    add_index :order_items, :order_id
    add_index :order_items, :product_variation_id
  end
end
