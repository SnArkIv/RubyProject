require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect when not logged in" do
    get admin_root_url
    assert_redirected_to new_user_session_url
  end

  test "should redirect for customer" do
    sign_in users(:one)
    get admin_root_url
    assert_redirected_to root_url
  end

  test "should get index for admin" do
    sign_in users(:two)
    get admin_root_url
    assert_response :success
  end

  test "should get index for manager" do
    sign_in users(:manager)
    get admin_root_url
    assert_response :success
  end
end
