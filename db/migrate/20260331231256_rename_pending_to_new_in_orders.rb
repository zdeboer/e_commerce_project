class RenamePendingToNewInOrders < ActiveRecord::Migration[7.1]
  def up
    Order.where(order_status: "pending").update_all(order_status: "new")
  end

  def down
    Order.where(order_status: "new").update_all(order_status: "pending")
  end
end