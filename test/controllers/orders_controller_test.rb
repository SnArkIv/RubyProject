require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should redirect new when not logged in" do
    get new_order_url
    assert_redirected_to new_user_session_url
  end

  test "should get index when logged in" do
    sign_in users(:one)
    get orders_url
    assert_response :success
    assert_select "h1", "История заказов"
  end

  test "should get new when logged in with cart items" do
    sign_in users(:one)
    post add_item_cart_url, params: { product_id: products(:one).id, size: "M" }
    get new_order_url
    assert_response :success
  end

  test "should create order when logged in" do
    sign_in users(:one)
    post add_item_cart_url, params: { product_id: products(:one).id, size: "M" }
    post orders_url, params: {
      order: {
        shipping_address: "Moscow, Test st.",
        delivery_method: "courier",
        payment_method: "cash"
      }
    }
    assert_redirected_to order_url(Order.last)
  end

  test "should repeat order" do
    sign_in users(:one)
    post repeat_order_url(orders(:one))
    assert_redirected_to cart_url
  end
end
