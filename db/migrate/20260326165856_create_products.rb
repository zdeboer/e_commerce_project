class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.integer :genre_id, null: false
      t.integer :media_type_id, null: false
      t.string :name
      t.string :description
      t.decimal :price

      t.timestamps
    end

    add_foreign_key :products, :media_types
    add_foreign_key :products, :genres

    add_index :products, :media_type_id
    add_index :products, :genre_id
  end
end