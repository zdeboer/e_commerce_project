ActiveAdmin.register Address do
  permit_params :customer_id, :address_line1, :address_line2, :city, :state,
                :postal_code, :country

  filter :customer
  filter :city
  filter :state
  filter :postal_code
  filter :country
  filter :created_at

  index do
    selectable_column
    id_column
    column :customer
    column :address_line1
    column :city
    column :state
    column :postal_code
    actions
  end
end
