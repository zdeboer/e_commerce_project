class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.references :genre, null: false, foreign_key: true
      t.references :media_type, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.decimal :price

      t.timestamps
    end
  end
end
