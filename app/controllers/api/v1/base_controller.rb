module Api
  module V1
    class BaseController < ActionController::API
      include Pagy::Backend

      before_action :authenticate_user!

      private

      def authenticate_user!
        header = request.headers["Authorization"]
        token = header.split(" ").last if header.present?

        decoded = JsonWebToken.decode(token)
        if decoded
          @current_user = User.find_by(id: decoded[:user_id])
        end

        render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
      end

      def current_user
        @current_user
      end

      def current_cart
        return @current_cart if defined?(@current_cart)

        if current_user
          @current_cart = current_user.cart || current_user.create_cart!(session_token: SecureRandom.hex(16))
        elsif request.headers["X-Cart-Token"].present?
          @current_cart = Cart.find_by(session_token: request.headers["X-Cart-Token"]) || create_guest_cart
        else
          @current_cart = create_guest_cart
        end
      end

      def create_guest_cart
        cart = Cart.create!(session_token: SecureRandom.hex(16))
        response.headers["X-Cart-Token"] = cart.session_token
        cart
      end
    end
  end
end
