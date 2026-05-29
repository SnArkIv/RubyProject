require "test_helper"

class CatalogControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get catalog_url
    assert_response :success
    assert_select "h1", "Каталог"
  end

  test "should filter by category" do
    get catalog_url, params: { category_id: categories(:tshirts).id }
    assert_response :success
  end

  test "should search products" do
    get catalog_url, params: { q: "shirt" }
    assert_response :success
  end

  test "should sort by price ascending" do
    get catalog_url, params: { sort: "price_asc" }
    assert_response :success
  end
end
