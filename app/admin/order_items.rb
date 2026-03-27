ActiveAdmin.register OrderItem do
  permit_params :order_id, :product_variation_id, :quantity, :unit_price

  filter :order
  filter :product_variation
  filter :quantity
  filter :created_at

  index do
    selectable_column
    id_column
    column :order
    column :product_variation
    column :quantity
    column :unit_price
    actions
  end
end