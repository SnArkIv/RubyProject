require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "should be valid with required fields" do
    order = orders(:one)
    assert order.valid?
  end

  test "should require total_amount" do
    order = Order.new(user: users(:one), shipping_address: "Test")
    assert_not order.valid?
  end

  test "should require shipping_address" do
    order = Order.new(user: users(:one), total_amount: 100)
    assert_not order.valid?
  end

  test "status enum works" do
    order = orders(:one)
    assert order.pending?
    order.delivered!
    assert order.delivered?
  end

  test "delivery_method_label returns human readable value" do
    assert_equal "Курьер", orders(:one).delivery_method_label
  end

  test "payment_method_label returns human readable value" do
    assert_equal "Наличные", orders(:one).payment_method_label
  end
end
