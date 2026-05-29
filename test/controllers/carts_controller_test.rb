require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "should show cart" do
    get cart_url
    assert_response :success
    assert_select "h1", "Корзина"
  end

  test "should add item to cart" do
    post add_item_cart_url, params: { product_id: products(:one).id, size: "M" }
    assert_redirected_to catalog_url
    follow_redirect!
    assert_match /Товар добавлен/, response.body
  end
end
