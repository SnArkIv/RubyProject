require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "total_amount sums final prices" do
    cart = carts(:one)
    expected = cart.cart_items.sum { |item| item.product.final_price * item.quantity }
    assert_equal expected, cart.total_amount
  end

  test "items_count sums quantities" do
    cart = carts(:one)
    assert_equal 2, cart.items_count
  end
end
