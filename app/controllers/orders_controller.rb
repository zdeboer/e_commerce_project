class OrdersController < ApplicationController
  before_action :authenticate_customer!

  TAX_RATES = {
    "AB" => { gst: 0.05, pst: 0.0, hst: 0.0 },
    "BC" => { gst: 0.05, pst: 0.07, hst: 0.0 },
    "MB" => { gst: 0.05, pst: 0.07, hst: 0.0 },
    "NB" => { gst: 0.0, pst: 0.0, hst: 0.15 },
    "NL" => { gst: 0.0, pst: 0.0, hst: 0.15 },
    "NS" => { gst: 0.0, pst: 0.0, hst: 0.15 },
    "NT" => { gst: 0.05, pst: 0.0, hst: 0.0 },
    "NU" => { gst: 0.05, pst: 0.0, hst: 0.0 },
    "ON" => { gst: 0.0, pst: 0.0, hst: 0.13 },
    "PE" => { gst: 0.0, pst: 0.0, hst: 0.15 },
    "QC" => { gst: 0.05, pst: 0.09975, hst: 0.0 },
    "SK" => { gst: 0.05, pst: 0.06, hst: 0.0 },
    "YT" => { gst: 0.05, pst: 0.0, hst: 0.0 }
  }.freeze

  NAME_TO_CODE = {
    "ALBERTA" => "AB",
    "BRITISH COLUMBIA" => "BC",
    "MANITOBA" => "MB",
    "NEW BRUNSWICK" => "NB",
    "NEWFOUNDLAND AND LABRADOR" => "NL",
    "NOVA SCOTIA" => "NS",
    "NORTHWEST TERRITORIES" => "NT",
    "NUNAVUT" => "NU",
    "ONTARIO" => "ON",
    "PRINCE EDWARD ISLAND" => "PE",
    "QUEBEC" => "QC",
    "SASKATCHEWAN" => "SK",
    "YUKON" => "YT"
  }.freeze

  def show
    @order = current_customer
      .orders
      .includes(:address, order_items: { product_variation: :product })
      .find(params[:id])

    @items = @order.order_items

    @subtotal = @items.sum do |item|
      (item.total_price || (item.unit_price || 0).to_d * item.quantity.to_i).to_d
    end

    @province_code = normalize_province(@order.address&.state)
    @taxes = compute_taxes(@subtotal, @province_code)

    @total = (@order.total_amount || (@subtotal + @taxes.values.sum)).to_d
  end

  def index
    @orders = current_customer.orders.order(order_date: :desc, created_at: :desc)
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
  end
end
