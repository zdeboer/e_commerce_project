class Page < ApplicationRecord
  before_save :sanitize_content

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      title slug content created_at updated_at
    ]
  end

  private

  def sanitize_content
    self.content = ActionController::Base.helpers.sanitize(
      content,
      tags:       %w[h1 h2 h3 h4 h5 h6 p br strong em b i u a ul ol li blockquote img],
      attributes: %w[href src alt title]
    )
  end
end
