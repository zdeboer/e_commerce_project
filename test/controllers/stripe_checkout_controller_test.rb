require "test_helper"

class StripeCheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stripe_checkout_create_url
    assert_response :success
  end

  test "should get success" do
    get stripe_checkout_success_url
    assert_response :success
  end
end
