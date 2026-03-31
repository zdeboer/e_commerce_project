class CheckoutsController < ApplicationController
before_action :authenticate_customer!

    def create
        cart_hash = session[:cart] || {}
        return redirect_to cart_path, alert: "Your cart is empty." if cart_hash.empty?

        if params[:address_id].present?
            address = current_customer.addresses.find(params[:address_id])
        else
            attrs = {
                address_line1: params[:address_line1].to_s.strip,
                city: params[:city].to_s.strip,
                state: params[:state].to_s.strip,
                postal_code: params[:postal_code].to_s.strip,
                country: params[:country].to_s.strip
            }

            # Try to reuse an existing identical address
            address = current_customer.addresses.find_by(attrs)

            # If not found, create a new one (validations will run here)
            address ||= current_customer.addresses.create!(attrs)
        end

        province_code = address.state&.strip&.upcase
        province = Province.find_by(code: province_code)

        if province
        gst = subtotal * province.gst
        pst = subtotal * province.pst
        hst = subtotal * province.hst
        else
        gst = pst = hst = 0
        end

            variations = ProductVariation.includes(:product).where(id: cart_hash.keys)

            subtotal = variations.sum do |v|
                v.product.price * cart_hash[v.id.to_s].to_i
            end

        total = subtotal + gst + pst + hst

        order = current_customer.orders.create!(
            address: address,
            order_date: Time.current,
            total_amount: total,
            order_status: "pending",
            payment_status: "unpaid",
            payment_method: "invoice"
        )

        variations.each do |variation|
            qty = cart_hash[variation.id.to_s].to_i
            next if qty <= 0

            unit_price = variation.product.price
            order.order_items.create!(
            product_variation: variation,
            quantity: qty,
            unit_price: unit_price,
            total_price: unit_price * qty
            )
        end

        session[:cart] = {}

        redirect_to order_path(order)
    end

    def show
    end
end
