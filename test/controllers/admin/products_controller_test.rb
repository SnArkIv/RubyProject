require "test_helper"

class Admin::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index for admin" do
    sign_in users(:two)
    get admin_products_url
    assert_response :success
  end

  test "should create product" do
    sign_in users(:two)
    post admin_products_url, params: {
      product: {
        name: "New Product",
        price: 100,
        category_id: categories(:tshirts).id,
        brand_id: brands(:forestwalk).id,
        status: "published"
      }
    }
    assert_redirected_to admin_products_url
  end

  test "should update product" do
    sign_in users(:two)
    patch admin_product_url(products(:one)), params: {
      product: { name: "Updated" }
    }
    assert_redirected_to admin_products_url
  end

  test "should destroy product" do
    sign_in users(:two)
    product = Product.create!(name: "To Delete", price: 10, category: categories(:tshirts), brand: brands(:forestwalk))
    assert_difference("Product.count", -1) do
      delete admin_product_url(product)
    end
    assert_redirected_to admin_products_url
  end
end
