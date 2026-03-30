class HomeController < ApplicationController
  def index
    @genres = Genre.order(:name)
    @featured_products = Product.includes(:genre, :media_type).order(created_at: :desc).limit(6)
  end
end
