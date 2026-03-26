class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.string :order_status
      t.string :payment_status
      t.string :payment_method
      t.string :shipment_tracking_number
      t.timestamp :order_date
      t.decimal :total_amount

      t.timestamps
    end
  end
end
