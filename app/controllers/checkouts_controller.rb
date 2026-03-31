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

        rates = {
            "MB" => { gst: 0.05, pst: 0.07, hst: 0.0 },
            "ON" => { gst: 0.0, pst: 0.0, hst: 0.13 },
            "BC" => { gst: 0.05, pst: 0.07, hst: 0.0 },
            "AB" => { gst: 0.05, pst: 0.0, hst: 0.0 },
            "QC" => { gst: 0.05, pst: 0.09975, hst: 0.0 },
            "NS" => { gst: 0.0, pst: 0.0, hst: 0.15 },
            "NB" => { gst: 0.0, pst: 0.0, hst: 0.15 },
            "NL" => { gst: 0.0, pst: 0.0, hst: 0.15 },
            "PE" => { gst: 0.0, pst: 0.0, hst: 0.15 },
            "SK" => { gst: 0.05, pst: 0.06, hst: 0.0 },
            "NT" => { gst: 0.05, pst: 0.0, hst: 0.0 },
            "NU" => { gst: 0.05, pst: 0.0, hst: 0.0 },
            "YT" => { gst: 0.05, pst: 0.0, hst: 0.0 }
            }

            raw_province = address.state.to_s.strip.upcase
            name_to_code = {
                "MANITOBA" => "MB",
                "ONTARIO" => "ON",
                "BRITISH COLUMBIA" => "BC",
                "ALBERTA" => "AB",
                "QUEBEC" => "QC",
                "NOVA SCOTIA" => "NS",
                "NEW BRUNSWICK" => "NB",
                "NEWFOUNDLAND AND LABRADOR" => "NL",
                "PRINCE EDWARD ISLAND" => "PE",
                "SASKATCHEWAN" => "SK",
                "NORTHWEST TERRITORIES" => "NT",
                "NUNAVUT" => "NU",
                "YUKON" => "YT"
                }

                # If user typed "Manitoba", convert to "MB"
                province_code = name_to_code[raw_province] || raw_province

            variations = ProductVariation.includes(:product).where(id: cart_hash.keys)

            subtotal = variations.sum do |v|
                v.product.price * cart_hash[v.id.to_s].to_i
            end

            rate = rates[province_code] || { gst: 0.0, pst: 0.0, hst: 0.0 }

            gst = subtotal * rate[:gst]
            pst = subtotal * rate[:pst]
            hst = subtotal * rate[:hst]

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
