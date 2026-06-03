module Api
  module V1
    class AuthController < ActionController::API
      def login
        user = User.find_by(email: params[:email].to_s.downcase.strip)
        if user&.valid_password?(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token, user: user_json(user) }
        else
          render json: { error: "Неверный email или пароль" }, status: :unauthorized
        end
      end

      def register
        user = User.new(user_params)
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token, user: user_json(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def me
        authenticate_user!
        render json: { user: user_json(current_user) }
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def user_json(user)
        {
          id: user.id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          phone: user.phone,
          role: user.role
        }
      end

      def authenticate_user!
        header = request.headers["Authorization"]
        token = header.split(" ").last if header.present?
        decoded = JsonWebToken.decode(token)
        @current_user = User.find_by(id: decoded[:user_id]) if decoded
        render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
      end

      def current_user
        @current_user
      end
    end
  end
end
