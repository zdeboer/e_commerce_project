class ProductVariation < ApplicationRecord
  belongs_to :product
  has_one :inventory, dependent: :destroy

  validates :variation_name, :variation_value, presence: true
  validates :product_id, numericality: { only_integer: true }

  def self.ransackable_attributes(_auth_object = nil)
    %w[variation_name variation_value product_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[product inventory]
  end
end
