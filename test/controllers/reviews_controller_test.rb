require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect create when not logged in" do
    post reviews_url, params: { product_id: products(:one).id, review: { rating: 5, comment: "Nice" } }
    assert_redirected_to new_user_session_url
  end

  test "should create review when logged in and ordered product" do
    sign_in users(:one)
    post reviews_url, params: { product_id: products(:one).id, review: { rating: 5, comment: "Great!" } }
    assert_redirected_to product_url(products(:one))
  end

  test "should destroy own review" do
    sign_in users(:one)
    delete review_url(reviews(:one))
    assert_redirected_to product_url(products(:one))
  end
end
