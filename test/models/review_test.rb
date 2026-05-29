require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "should be valid with rating 1-5" do
    review = Review.new(user: users(:two), product: products(:one), rating: 4)
    assert review.valid?
  end

  test "should reject rating outside 1-5" do
    review = Review.new(user: users(:two), product: products(:one), rating: 6)
    assert_not review.valid?
  end

  test "should require unique user-product pair" do
    review = Review.new(user: users(:one), product: products(:one), rating: 5)
    assert_not review.valid?
  end

  test "creating review updates product average_rating" do
    product = products(:two)
    product.reviews.create!(user: users(:two), rating: 1, comment: "Bad")
    product.reload
    assert_equal 2.0, product.average_rating
  end
end
