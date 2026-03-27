class Address < ApplicationRecord
  belongs_to :customer

  def self.ransackable_attributes(auth_object = nil)
    %w[
      address_line1 address_line2 city state postal_code country
      customer_id created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[customer]
  end

  validates :address_line1, :city, :state, :postal_code, :country, presence: true
end
