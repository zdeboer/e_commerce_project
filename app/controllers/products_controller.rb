class ProductsController < ApplicationController
  def index
    @products = Product.includes(:genre, :media_type).order(:name)
  end

  def show
    @product = Product.includes(product_variations: :inventory).find(params[:id])
    @variations = @product.product_variations.order(:variation_name, :variation_value)
  end
end
