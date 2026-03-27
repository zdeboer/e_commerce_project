class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items, id: :uuid do |t|
      t.uuid :order_id, null: false
      t.uuid :product_variation_id, null: false

      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_foreign_key :order_items, :orders
    add_foreign_key :order_items, :product_variations

    add_index :order_items, :order_id
    add_index :order_items, :product_variation_id
  end
end