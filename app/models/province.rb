class Province < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name code gst pst hst created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  validates :gst, :pst, :hst,
            numericality: { greater_than_or_equal_to: 0 }
end
