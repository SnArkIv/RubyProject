module Api
  module V1
    class ProfilesController < BaseController
      def show
        render json: {
          user: {
            id: current_user.id,
            email: current_user.email,
            role: current_user.role,
            created_at: current_user.created_at
          }
        }
      end

      def update
        if current_user.update(profile_params)
          render json: { user: { id: current_user.id, email: current_user.email }, message: "Профиль обновлён" }
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        params.require(:user).permit(:email)
      end
    end
  end
end
