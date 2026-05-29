require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  test "should redirect index when not logged in" do
    get favorites_url
    assert_redirected_to new_user_session_url
  end

  test "should get index when logged in" do
    sign_in users(:one)
    get favorites_url
    assert_response :success
    assert_select "h1", "Избранное"
  end

  test "should create favorite" do
    sign_in users(:two)
    post favorites_url, params: { product_id: products(:one).id }
    assert_redirected_to catalog_url
  end

  test "should destroy favorite" do
    sign_in users(:one)
    delete favorite_url(favorites(:one))
    assert_redirected_to catalog_url
  end
end
