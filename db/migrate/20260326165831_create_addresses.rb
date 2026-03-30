class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.integer :customer_id, null: false

      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country

      t.timestamps
    end

    add_foreign_key :addresses, :customers
    add_index :addresses, :customer_id
  end
end
