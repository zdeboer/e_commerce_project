class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders, id: :uuid do |t|
      t.uuid :customer_id, null: false
      t.uuid :address_id

      t.datetime :order_date, null: false
      t.string :shipment_tracking_number

      t.decimal :total_amount, precision: 10, scale: 2, null: false

      t.string :order_status, null: false, default: "pending"
      t.string :payment_status, null: false, default: "unpaid"
      t.string :payment_method

      t.timestamps
    end

    add_foreign_key :orders, :customers
    add_foreign_key :orders, :addresses

    add_index :orders, :customer_id
    add_index :orders, :address_id
  end
end