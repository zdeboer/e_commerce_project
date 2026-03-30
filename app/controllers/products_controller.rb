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

    @sort = params[:sort].to_s

    case @sort
    when "newest"
      scope = scope.order(created_at: :desc, name: :asc)

    when "updated"
      scope = scope
                .where("products.updated_at >= ?", 3.days.ago)
                .order(updated_at: :desc, name: :asc)

    else
      scope = scope.order(:name)
    end

    @products = scope.page(params[:page]).per(12)
  end

  def show
    @product = Product.includes(product_variations: :inventory).find(params[:id])
    @variations = @product.product_variations.order(:variation_name, :variation_value)
  end
end
