class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      transfer_guest_cart_to(user)
    end
  end

  private

  def transfer_guest_cart_to(user)
    guest_cart = Cart.find_by(session_token: session[:cart_token])
    return unless guest_cart&.cart_items&.any?

    user_cart = user.cart || user.create_cart!(session_token: SecureRandom.hex(16))
    guest_cart.cart_items.each do |item|
      existing = user_cart.cart_items.find_by(product_id: item.product_id, size: item.size)
      if existing
        existing.update!(quantity: existing.quantity + item.quantity)
      else
        user_cart.cart_items.create!(product_id: item.product_id, size: item.size, quantity: item.quantity)
      end
    end
    guest_cart.destroy
    session.delete(:cart_token)
  end
end
