ActiveAdmin.register ProductVariation do
  permit_params :product_id, :variation_name, :variation_value

  filter :product
  filter :variation_name
  filter :created_at

  remove_filter :inventory

  index do
    selectable_column
    id_column
    column :product
    column :variation_name
    column :variation_value
    actions
  end
end