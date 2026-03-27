class MediaType < ApplicationRecord
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end
end