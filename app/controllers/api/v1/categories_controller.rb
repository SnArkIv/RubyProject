module Api
  module V1
    class CategoriesController < BaseController
      skip_before_action :authenticate_user!, only: [ :index ]

      def index
        @categories = Category.order(:name)
      end
    end
  end
end
