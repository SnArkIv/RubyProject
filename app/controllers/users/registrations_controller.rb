class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      transfer_guest_cart_to(user) if user.persisted?
    end
  end

  protected

  def after_sign_up_path_for(resource)
    catalog_path
  end

  def after_update_path_for(resource)
    profile_path
  end

  private

  def transfer_guest_cart_to(user)
    guest_cart = Cart.find_by(session_token: session[:cart_token])
    return unless guest_cart&.cart_items&.any?

    user_cart = user.create_cart!(session_token: SecureRandom.hex(16))
    guest_cart.cart_items.each do |item|
      user_cart.cart_items.create!(product_id: item.product_id, size: item.size, quantity: item.quantity)
    end
    guest_cart.destroy
    session.delete(:cart_token)
  end
end
