require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  test "should be valid" do
    favorite = Favorite.new(user: users(:two), product: products(:one))
    assert favorite.valid?
  end

  test "should require unique user-product pair" do
    favorite = Favorite.new(user: users(:one), product: products(:one))
    assert_not favorite.valid?
  end
end
