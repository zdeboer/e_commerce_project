ActiveAdmin.register Inventory do
  permit_params :product_variation_id, :quantity, :last_updated

  filter :product_variation
  filter :quantity
  filter :last_updated

  index do
    selectable_column
    id_column
    column :product_variation
    column :quantity
    column :last_updated
    actions
  end
end
