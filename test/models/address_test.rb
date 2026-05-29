require "test_helper"

class AddressTest < ActiveSupport::TestCase
  test "should be valid with required fields" do
    address = addresses(:one)
    assert address.valid?
  end

  test "should require full_name" do
    address = Address.new(phone: "123", city: "Moscow", street: "Lenin", house: "1")
    assert_not address.valid?
  end

  test "setting default unsets others" do
    addr = addresses(:two)
    addr.update!(is_default: true)
    addresses(:one).reload
    assert_not addresses(:one).is_default?
    assert addr.is_default?
  end
end
