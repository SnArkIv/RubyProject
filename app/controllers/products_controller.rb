class ProductsController < ApplicationController
  def show
    @product = Product.includes(:category, :brand, images_attachments: :blob, reviews: :user).find(params[:id])
    @catalog_params = params.permit(:category_id, :brand_id, :gender, :sort, :q).to_h.compact_blank
    @similar_products = Product.similar(@product)
    @review = Review.new
    @reviews = @product.reviews.order(created_at: :desc)
    @favorite = current_user&.favorites&.find_by(product: @product)
  end
end
