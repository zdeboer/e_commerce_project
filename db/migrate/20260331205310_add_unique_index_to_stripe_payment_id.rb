class AddUniqueIndexToStripePaymentId < ActiveRecord::Migration[7.1]
  def change
    add_index :orders, :stripe_payment_id, unique: true
  end
end