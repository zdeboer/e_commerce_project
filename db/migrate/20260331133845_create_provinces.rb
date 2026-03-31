class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces do |t|
      t.string  :name, null: false
      t.string  :code, null: false
      t.decimal :gst, precision: 7, scale: 5, null: false, default: 0
      t.decimal :pst, precision: 7, scale: 5, null: false, default: 0
      t.decimal :hst, precision: 7, scale: 5, null: false, default: 0

      t.timestamps
    end

    add_index :provinces, :code, unique: true
  end
end
