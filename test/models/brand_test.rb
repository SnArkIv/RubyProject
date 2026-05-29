require "test_helper"

class BrandTest < ActiveSupport::TestCase
  test "should be valid with name" do
    brand = Brand.new(name: "New Brand")
    assert brand.valid?
  end

  test "should require name" do
    brand = Brand.new
    assert_not brand.valid?
  end

  test "should require unique name" do
    brand = Brand.new(name: brands(:forestwalk).name)
    assert_not brand.valid?
  end
end
