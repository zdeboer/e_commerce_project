class Product < ApplicationRecord
  belongs_to :genre
  belongs_to :media_type

  has_many :product_variations, dependent: :destroy
  has_many :inventory_items, through: :product_variations, source: :inventory

  def self.ransackable_attributes(auth_object = nil)
    %w[name description price sku media_type_id genre_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[media_type genre product_variations inventory_items]
  end

  validates :name, :description, :price, presence: true
end
