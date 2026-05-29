require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should be valid with name" do
    category = Category.new(name: "New Category")
    assert category.valid?
  end

  test "should require name" do
    category = Category.new
    assert_not category.valid?
  end

  test "should require unique name" do
    category = Category.new(name: categories(:tshirts).name)
    assert_not category.valid?
  end
end
