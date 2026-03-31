class Province < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  validates :gst, :pst, :hst,
            numericality: { greater_than_or_equal_to: 0 }
end
