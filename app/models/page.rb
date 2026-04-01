class Page < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[
      title slug content created_at updated_at
    ]
  end
end
