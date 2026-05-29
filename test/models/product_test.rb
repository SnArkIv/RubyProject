require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should be valid with required fields" do
    product = Product.new(
      name: "Test",
      price: 100,
      category: categories(:tshirts),
      brand: brands(:forestwalk)
    )
    assert product.valid?
  end

  test "should require name" do
    product = products(:one)
    product.name = nil
    assert_not product.valid?
  end

  test "should require price" do
    product = products(:one)
    product.price = nil
    assert_not product.valid?
  end

  test "final_price applies discount" do
    product = products(:two)
    assert_equal 180.0, product.final_price
  end

  test "final_price without discount equals price" do
    product = products(:one)
    assert_equal 100.0, product.final_price
  end

  test "on_sale? returns true when discount > 0" do
    assert products(:two).on_sale?
    assert_not products(:one).on_sale?
  end

  test "published scope returns only published products" do
    assert_includes Product.published, products(:one)
  end

  test "search finds by name" do
    assert_includes Product.search("shirt"), products(:one)
  end

  test "search finds by sku" do
    assert_includes Product.search("FIX-001"), products(:one)
  end

  test "update_average_rating recalculates rating" do
    product = products(:one)
    product.update_average_rating
    assert_equal 5.0, product.average_rating
  end
end
