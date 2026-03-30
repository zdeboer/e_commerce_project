ActiveAdmin.register Order do
  permit_params :customer_id, :address_id, :order_date, :shipment_tracking_number,
                :total_amount, :order_status, :payment_status, :payment_method

  filter :customer
  filter :order_status
  filter :payment_status
  filter :payment_method
  filter :created_at

  remove_filter :order_items
  remove_filter :address

  index do
    selectable_column
    id_column
    column :customer
    column :order_status
    column :payment_status
    column :total_amount
    actions
  end
end
