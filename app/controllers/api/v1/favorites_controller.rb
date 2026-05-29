module Api
  module V1
    class FavoritesController < BaseController
      def index
        @favorites = current_user.favorites.includes(product: [:category, :brand, { images_attachments: :blob }])
      end

      def create
        product = Product.find(params[:product_id])
        favorite = current_user.favorites.create!(product: product)
        render json: { message: "Добавлено в избранное", favorite: favorite_json(favorite) }, status: :created
      rescue ActiveRecord::RecordInvalid
        render json: { error: "Уже в избранном" }, status: :unprocessable_entity
      end

      def destroy
        favorite = current_user.favorites.find(params[:id])
        favorite.destroy
        render json: { message: "Удалено из избранного" }
      end

      private

      def favorite_json(favorite)
        {
          id: favorite.id,
          product: {
            id: favorite.product.id,
            name: favorite.product.name,
            price: favorite.product.price,
            final_price: favorite.product.final_price,
            image_url: favorite.product.images.attached? ? url_for(favorite.product.images.first) : nil
          }
        }
      end
    end
  end
end
