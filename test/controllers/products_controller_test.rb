require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should show product" do
    get product_url(products(:one))
    assert_response :success
    assert_select "h1", products(:one).name
  end
end
