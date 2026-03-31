class StripeCheckoutController < ApplicationController
  before_action :authenticate_customer!

  def create
    order = current_customer.orders.find(params[:order_id])

    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      line_items:           order.order_items.map do |item|
        {
          price_data: {
            currency:     "cad",
            product_data: {
              name: item.product_variation.product.name
            },
            unit_amount:  (item.unit_price * 100).to_i
          },
          quantity:   item.quantity
        }
      end,
      mode:                 "payment",
      success_url:          checkout_success_url(order_id: order.id),
      cancel_url:           order_url(order)
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
    order = current_customer.orders.find(params[:order_id])
    order.update(
      order_status:   :paid,
      payment_status: :paid
    )
  end
end
