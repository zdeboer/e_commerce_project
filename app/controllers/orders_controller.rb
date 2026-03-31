class OrdersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders.order(order_date: :desc, created_at: :desc)
  end

  def show
    @order = current_customer
             .orders
             .includes(:address, order_items: { product_variation: :product })
             .find(params[:id])

    @items = @order.order_items

    @subtotal = @items.sum do |item|
      (item.total_price || ((item.unit_price || 0).to_d * item.quantity.to_i)).to_d
    end

    @province_code = @order.address.state&.strip&.upcase

    @taxes = compute_taxes(@subtotal, @province_code)

    @total = (@order.total_amount || (@subtotal + @taxes.values.sum)).to_d
  end

  private

  def normalize_province(value)
    raw = value.to_s.strip
    return "" if raw.blank?

    up = raw.upcase
    NAME_TO_CODE[up] || up
  end

  def compute_taxes(subtotal, province_code)
    province = Province.find_by(code: province_code)

    if province
      gst = subtotal * province.gst
      pst = subtotal * province.pst
      hst = subtotal * province.hst
    else
      gst = pst = hst = 0
    end

    {
      gst: gst,
      pst: pst,
      hst: hst
    }
  end
end
