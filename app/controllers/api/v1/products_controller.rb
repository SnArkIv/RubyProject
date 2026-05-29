module Api
  module V1
    class ProductsController < BaseController
      skip_before_action :authenticate_user!, only: [ :show ]

      def show
        @product = Product.includes(:category, :brand, images_attachments: :blob, reviews: :user).find(params[:id])
        @similar_products = Product.similar(@product)
        @reviews = @product.reviews.order(created_at: :desc)
      end
    end
  end
end
