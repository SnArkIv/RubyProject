class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

  helper_method :current_cart

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def pagy_url_for(pagy, page, absolute: false, html_escaped: false)
    query_params = request.query_parameters.merge(page: page)
    "#{request.path}?#{query_params.to_query}"
  end

  private

  def not_found
    flash[:alert] = "Товар не найден. Возможно, он был удалён или ID изменился."
    redirect_to catalog_path
  end

  def current_cart
    return @current_cart if defined?(@current_cart)

    if current_user
      @current_cart = current_user.cart || current_user.create_cart!(session_token: SecureRandom.hex(16))
    elsif session[:cart_token]
      @current_cart = Cart.find_by(session_token: session[:cart_token]) || create_guest_cart
    else
      @current_cart = create_guest_cart
    end
  end

  def create_guest_cart
    cart = Cart.create!(session_token: SecureRandom.hex(16))
    session[:cart_token] = cart.session_token
    cart
  end
end
