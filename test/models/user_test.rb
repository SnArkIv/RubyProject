require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid with email and password" do
    user = User.new(email: "test@example.com", password: "password12", password_confirmation: "password12")
    assert user.valid?
  end

  test "should require email" do
    user = User.new(password: "password12")
    assert_not user.valid?
    assert user.errors[:email].any? { |e| e.include?("blank") || e.include?("почты") }
  end

  test "should require unique email" do
    user = User.new(email: users(:one).email, password: "password12")
    assert_not user.valid?
  end

  test "default role should be customer" do
    user = User.create!(email: "new@example.com", password: "password12", password_confirmation: "password12")
    assert user.customer?
  end

  test "admin? returns true for admin role" do
    assert users(:two).admin?
    assert_not users(:one).admin?
  end

  test "manager? returns true for manager role" do
    assert users(:manager).manager?
    assert_not users(:one).manager?
  end

  test "admin_or_manager? returns true for admin and manager" do
    assert users(:two).admin_or_manager?
    assert users(:manager).admin_or_manager?
    assert_not users(:one).admin_or_manager?
  end
end
