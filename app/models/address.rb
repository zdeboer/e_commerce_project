class Address < ApplicationRecord
  belongs_to :customer

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      address_line1 address_line2 city state postal_code country
      customer_id created_at updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customer]
  end

  def full_display
    "#{address_line1}, #{city}, #{state}, #{postal_code}, #{country}"
  end

  validates :address_line1, :city, :state, :postal_code, :country, presence: true
end
