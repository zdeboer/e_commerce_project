ActiveAdmin.register Customer do
  permit_params :first_name, :last_name, :email, :phone

  # SAFE FILTERS ONLY
  filter :first_name
  filter :last_name
  filter :email
  filter :created_at

  # REMOVE UNSAFE FILTERS
  remove_filter :addresses
  remove_filter :orders

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :phone
    actions
  end

  form do |f|
    f.inputs "Customer Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
    end
    f.actions
  end
end
