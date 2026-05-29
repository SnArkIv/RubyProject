module Api
  module V1
    class AddressesController < BaseController
      def index
        @addresses = current_user.addresses.order(is_default: :desc, created_at: :desc)
      end

      def create
        @address = current_user.addresses.build(address_params)
        if @address.save
          render json: { address: @address, message: "Адрес добавлен" }, status: :created
        else
          render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @address = current_user.addresses.find(params[:id])
        if @address.update(address_params)
          render json: { address: @address, message: "Адрес обновлён" }
        else
          render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @address = current_user.addresses.find(params[:id])
        @address.destroy
        render json: { message: "Адрес удалён" }
      end

      private

      def address_params
        params.require(:address).permit(:full_name, :phone, :city, :street, :house, :apartment, :zip_code, :is_default)
      end
    end
  end
end
