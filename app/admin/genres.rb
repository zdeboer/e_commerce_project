ActiveAdmin.register Genre do
  permit_params :name

  filter :name
  filter :created_at

  remove_filter :products

  index do
    selectable_column
    id_column
    column :name
    actions
  end
end