require "test_helper"

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index for admin" do
    sign_in users(:two)
    get admin_orders_url
    assert_response :success
  end

  test "should update order status" do
    sign_in users(:two)
    patch admin_order_url(orders(:one)), params: { order: { status: "confirmed" } }
    assert_redirected_to admin_order_url(orders(:one))
    assert orders(:one).reload.confirmed?
  end
end
