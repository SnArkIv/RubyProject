module Api
  module V1
    class PromoCodesController < BaseController
      skip_before_action :authenticate_user!, only: [ :validate ]

      def validate
        code = PromoCode.active.find_by(code: params[:code])

        if code && code.valid_for_use?
          render json: { discount: code.discount, code: code.code }
        else
          render json: { error: "Промокод не найден или истёк" }, status: :not_found
        end
      end
    end
  end
end