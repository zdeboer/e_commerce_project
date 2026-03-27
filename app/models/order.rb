class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :address, optional: true

  has_many :order_items, dependent: :destroy

  enum order_status: { pending: "pending", paid: "paid", shipped: "shipped" }, _prefix: true
  enum payment_status: { unpaid: "unpaid", paid: "paid" }, _prefix: true

  validates :order_date, :total_amount, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      customer_id address_id order_date shipment_tracking_number
      total_amount order_status payment_status payment_method
      created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[customer address order_items]
  end
end