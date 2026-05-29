require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index for admin" do
    sign_in users(:two)
    get admin_users_url
    assert_response :success
  end

  test "should update user role" do
    sign_in users(:two)
    patch admin_user_url(users(:one)), params: { user: { role: "manager" } }
    assert_redirected_to admin_users_url
    assert users(:one).reload.manager?
  end

  test "manager cannot edit user roles" do
    sign_in users(:manager)
    get edit_admin_user_url(users(:one))
    assert_redirected_to admin_users_url
  end
end
