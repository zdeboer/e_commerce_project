# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "Recent Orders" do
          table_for Order.includes(:customer).order(created_at: :desc).limit(10) do
            column("Order") { |o| link_to("##{o.id}", admin_order_path(o)) }
            column("Customer") { |o| link_to(o.customer.email, admin_customer_path(o.customer)) }
            column :order_status
            column :payment_status
            column("Total") { |o| helpers.number_to_currency(o.total_amount) }
            column("Placed") { |o| o.order_date || o.created_at }
          end
        end
      end

      column do
        panel "Customers With Orders" do
          customers = Customer
            .left_joins(:orders)
            .select("customers.*, COUNT(orders.id) AS orders_count, COALESCE(SUM(orders.total_amount), 0) AS total_spent")
            .group("customers.id")
            .having("COUNT(orders.id) > 0")
            .order("orders_count DESC")

          table_for customers.limit(10) do
            column("Customer") { |c| link_to("#{c.first_name} #{c.last_name}".strip, admin_customer_path(c)) }
            column("Email", &:email)
            column("Orders") { |c| c.attributes["orders_count"] }
            column("Total spent") { |c| helpers.number_to_currency(c.attributes["total_spent"]) }
          end
        end
      end
    end
  end # content
end
