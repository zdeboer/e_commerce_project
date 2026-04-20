class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :address, optional: true

  has_many :order_items, dependent: :destroy

  enum :order_status, { new: "new", paid: "paid", shipped: "shipped" }, prefix: true
  enum :payment_status, { unpaid: "unpaid", paid: "paid" }, prefix: true

  validates :order_date, :total_amount, presence: true
  validates :stripe_payment_id, uniqueness: true, allow_nil: true
  validates :customer_id, :address_id, numericality: { only_integer: true }

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      customer_id address_id order_date shipment_tracking_number
      total_amount order_status payment_status payment_method
      created_at updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customer address order_items]
  end
end
