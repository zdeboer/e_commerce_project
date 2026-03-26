class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories do |t|
      t.references :product_variation, null: false, foreign_key: true
      t.integer :quantity
      t.timestamp :last_updated

      t.timestamps
    end
  end
end
