class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone

      t.timestamps
    end

    add_index :customers, :email, unique: true
  end
end