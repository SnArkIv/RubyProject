module Api
  module V1
    class ReviewsController < BaseController
      skip_before_action :authenticate_user!, only: [ :index ]

      def index
        product = Product.find(params[:product_id])
        @reviews = product.reviews.includes(:user).order(created_at: :desc)
      end

      def create
        product = Product.find(params[:product_id])
        @review = current_user.reviews.build(review_params.merge(product: product))

        if @review.save
          render json: { message: "Отзыв добавлен", review: review_json(@review) }, status: :created
        else
          render json: { errors: @review.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @review = current_user.reviews.find(params[:id])
        @review.destroy
        render json: { message: "Отзыв удалён" }
      end

      private

      def review_params
        params.require(:review).permit(:rating, :comment)
      end

      def review_json(review)
        {
          id: review.id,
          rating: review.rating,
          comment: review.comment,
          user: { email: review.user.email },
          created_at: review.created_at
        }
      end
    end
  end
end
