class CheckoutsController < ApplicationController
  before_action :authenticate_customer!

  def show; end

  def create
    return redirect_to cart_path, alert: "Your cart is empty." if cart_hash.empty?

    address = find_or_create_address
    subtotal = calculate_subtotal
    taxes = calculate_taxes(address, subtotal)

    order = create_order(address, subtotal + taxes.sum)
    create_order_items(order)

    session[:cart] = {}
    redirect_to order_path(order)
  end

  private

  def cart_hash
    @cart_hash ||= session[:cart] || {}
  end

  def find_or_create_address
    return current_customer.addresses.find(params[:address_id]) if params[:address_id].present?

    attrs = {
      address_line1: params[:address_line1].to_s.strip,
      city:          params[:city].to_s.strip,
      state:         params[:state].to_s.strip,
      postal_code:   params[:postal_code].to_s.strip,
      country:       params[:country].to_s.strip
    }
    current_customer.addresses.find_or_create_by!(attrs)
  end

  def calculate_subtotal
    @variations = ProductVariation.includes(:product).where(id: cart_hash.keys)
    @variations.sum { |v| v.product.price * cart_hash[v.id.to_s].to_i }
  end

  def calculate_taxes(address, subtotal)
    province = Province.find_by(code: address.state&.strip&.upcase)
    return [0, 0, 0] unless province

    [subtotal * province.gst, subtotal * province.pst, subtotal * province.hst]
  end

  def create_order(address, total)
    current_customer.orders.create!(
      address: address, total_amount: total, order_date: Time.current,
      order_status: "pending", payment_status: "unpaid", payment_method: "invoice"
    )
  end

  def create_order_items(order)
    @variations.each do |variation|
      qty = cart_hash[variation.id.to_s].to_i
      next if qty <= 0

      order.order_items.create!(
        product_variation: variation, quantity: qty,
        unit_price: variation.product.price, total_price: variation.product.price * qty
      )
    end
  end
end
