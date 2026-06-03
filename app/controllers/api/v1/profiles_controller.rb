module Api
  module V1
    class ProfilesController < BaseController
      def show
        render json: {
          user: {
            id: current_user.id,
            email: current_user.email,
            first_name: current_user.first_name,
            last_name: current_user.last_name,
            phone: current_user.phone,
            role: current_user.role,
            created_at: current_user.created_at
          }
        }
      end

      def update
        if current_user.update(profile_params)
          render json: { user: { id: current_user.id, email: current_user.email, first_name: current_user.first_name, last_name: current_user.last_name, phone: current_user.phone }, message: "Профиль обновлён" }
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        params.require(:user).permit(:email, :first_name, :last_name, :phone)
      end
    end
  end
end
