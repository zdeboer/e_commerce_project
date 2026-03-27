class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :sku, null: false

      t.uuid :media_type_id, null: false
      t.uuid :genre_id, null: false

      t.timestamps
    end

    add_foreign_key :products, :media_types
    add_foreign_key :products, :genres

    add_index :products, :media_type_id
    add_index :products, :genre_id
    add_index :products, :sku, unique: true
  end
end