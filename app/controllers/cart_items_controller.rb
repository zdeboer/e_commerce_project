class CartItemsController < ApplicationController
  def create
    id = params[:product_variation_id].to_s
    cart[id] = cart[id].to_i + (params[:quantity] || 1).to_i
    redirect_to cart_path
  end

  def update
    id = params[:id].to_s
    quantity = params[:quantity].to_i

    if quantity <= 0
      cart.delete(id)
    else
      cart[id] = quantity
    end

    redirect_to cart_path
  end

  def destroy
    cart.delete(params[:id].to_s)
    redirect_to cart_path
  end
end
