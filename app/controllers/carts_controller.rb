class CartsController < ApplicationController
  def show
    cart_hash = cart

    @variations = ProductVariation
                    .includes(:product, :inventory)
                    .where(id: cart_hash.keys)

    @line_items = @variations.map do |variation|
      quantity = cart_hash[variation.id.to_s].to_i
      {
        variation: variation,
        product: variation.product,
        quantity: quantity,
        subtotal: variation.product.price * quantity
      }
    end
  end
end
