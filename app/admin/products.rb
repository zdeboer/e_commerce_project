ActiveAdmin.register Product do
  permit_params :name, :description, :price, :sku, :media_type_id, :genre_id

  # Safe filters only
  filter :name
  filter :price
  filter :media_type
  filter :genre
  filter :created_at

  # Remove unsafe has_many filters
  remove_filter :product_variations
  remove_filter :inventory_items

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :media_type
    column :genre
    actions
  end
end