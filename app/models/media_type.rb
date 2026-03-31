class MediaType < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  def self.ransackable_attributes(_auth_object = nil)
    %w[name created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[products]
  end
end
