class ProductsController < ApplicationController
  def index
    @q = params[:q].to_s.strip
    @genres = Genre.order(:name)
    @genre_id = params[:genre_id].presence

    scope = Product.includes(:genre, :media_type)

    if @genre_id.present?
      scope = scope.where(genre_id: @genre_id)
    end

    if @q.present?
      escaped = ActiveRecord::Base.sanitize_sql_like(@q)
      scope = scope.where(
        "products.name LIKE :q OR products.description LIKE :q",
        q: "%#{escaped}%"
      )
    end

    @products = scope.order(:name)
  end

  def show
    @product = Product.includes(product_variations: :inventory).find(params[:id])
    @variations = @product.product_variations.order(:variation_name, :variation_value)
  end
end
