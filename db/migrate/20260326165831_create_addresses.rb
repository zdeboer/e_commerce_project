class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses, id: :uuid do |t|
      t.uuid :customer_id, null: false

      t.string :address_line1, null: false
      t.string :address_line2
      t.string :city, null: false
      t.string :state, null: false
      t.string :postal_code, null: false
      t.string :country, null: false

      t.timestamps
    end

    add_foreign_key :addresses, :customers
    add_index :addresses, :customer_id
  end
end