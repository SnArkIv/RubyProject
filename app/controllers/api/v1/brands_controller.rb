module Api
  module V1
    class BrandsController < BaseController
      skip_before_action :authenticate_user!, only: [ :index ]

      def index
        @brands = Brand.order(:name)
      end
    end
  end
end
