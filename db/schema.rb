# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_03_26_170602) do
  create_table "addresses", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_addresses_on_customer_id"
  end

  create_table "adminusers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_adminusers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_adminusers_on_reset_password_token", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "product_variation_id", null: false
    t.integer "quantity"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_variation_id"], name: "index_inventories_on_product_variation_id"
  end

  create_table "media_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_variation_id", null: false
    t.integer "quantity"
    t.decimal "unit_price"
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_variation_id"], name: "index_order_items_on_product_variation_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "address_id", null: false
    t.string "order_status"
    t.string "payment_status"
    t.string "payment_method"
    t.string "shipment_tracking_number"
    t.datetime "order_date"
    t.decimal "total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  create_table "product_variations", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "variation_name"
    t.string "variation_value"
    t.string "sku"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variations_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "genre_id", null: false
    t.integer "media_type_id", null: false
    t.string "name"
    t.string "description"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_products_on_genre_id"
    t.index ["media_type_id"], name: "index_products_on_media_type_id"
  end

  add_foreign_key "addresses", "customers"
  add_foreign_key "inventories", "product_variations"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "product_variations"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "customers"
  add_foreign_key "product_variations", "products"
  add_foreign_key "products", "genres"
  add_foreign_key "products", "media_types"
end
