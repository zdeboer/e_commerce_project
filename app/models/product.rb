class Product < ApplicationRecord
  belongs_to :genre
  belongs_to :media_type
end
