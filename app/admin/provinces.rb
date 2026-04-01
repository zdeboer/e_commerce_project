ActiveAdmin.register Province do
  # Strong parameters
  permit_params :name, :code, :gst, :pst, :hst

  # Index page
  index do
    selectable_column
    id_column
    column :name
    column :code
    column :gst
    column :pst
    column :hst
    actions
  end

  # Filters
  filter :name
  filter :code
  filter :gst
  filter :pst
  filter :hst

  # Form
  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :code, hint: "Two-letter code (e.g., MB, ON, BC)"
      f.input :gst, label: "GST Rate", hint: "Example: 0.05"
      f.input :pst, label: "PST Rate", hint: "Example: 0.07"
      f.input :hst, label: "HST Rate", hint: "Example: 0.13"
    end
    f.actions
  end

  # Show page
  show do
    attributes_table do
      row :name
      row :code
      row :gst
      row :pst
      row :hst
      row :created_at
      row :updated_at
    end
  end
end