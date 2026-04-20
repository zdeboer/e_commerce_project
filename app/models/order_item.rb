class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product_variation

  validates :quantity, :unit_price, presence: true
  validates :order_id, :product_variation_id, numericality: { only_integer: true }

  def self.ransackable_attributes(_auth_object = nil)
    %w[order_id product_variation_id quantity unit_price created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[order product_variation]
  end
end
