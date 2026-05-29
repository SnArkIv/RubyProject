require "test_helper"

class AddressesControllerTest < ActionDispatch::IntegrationTest
  test "should redirect index when not logged in" do
    get addresses_url
    assert_redirected_to new_user_session_url
  end

  test "should get index when logged in" do
    sign_in users(:one)
    get addresses_url
    assert_response :success
    assert_select "h1", "Адреса доставки"
  end

  test "should create address" do
    sign_in users(:one)
    post addresses_url, params: {
      address: {
        full_name: "Test User",
        phone: "+79999999999",
        city: "Moscow",
        street: "Test",
        house: "1"
      }
    }
    assert_redirected_to addresses_url
  end

  test "should update address" do
    sign_in users(:one)
    patch address_url(addresses(:one)), params: {
      address: { full_name: "Updated Name" }
    }
    assert_redirected_to addresses_url
  end

  test "should destroy address" do
    sign_in users(:one)
    delete address_url(addresses(:two))
    assert_redirected_to addresses_url
  end
end
