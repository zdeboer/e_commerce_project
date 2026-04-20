class Inventory < ApplicationRecord
  belongs_to :product_variation

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :product_variation_id, numericality: { only_integer: true }

  def self.ransackable_attributes(_auth_object = nil)
    %w[quantity last_updated product_variation_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[product_variation]
  end
end
