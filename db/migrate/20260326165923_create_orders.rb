class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id, null: false
      t.integer :address_id, null: false
      t.string :order_status
      t.string :payment_status
      t.string :payment_method
      t.string :shipment_tracking_number
      t.datetime :order_date
      t.decimal :total_amount

      t.timestamps
    end

    add_foreign_key :orders, :customers
    add_foreign_key :orders, :addresses

    add_index :orders, :customer_id
    add_index :orders, :address_id
  end
end