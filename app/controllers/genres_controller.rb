class GenresController < ApplicationController
  def show
    @genre = Genre.find(params[:id])
    @products = @genre.products.includes(:media_type).order(:name)
  end
end
