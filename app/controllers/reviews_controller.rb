class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @product = Product.find(params[:product_id])

    unless current_user.orders.joins(:order_items)
                          .where(order_items: { product_id: @product.id }, status: :delivered)
                          .exists?
      redirect_to product_path(@product), alert: "Вы можете оставить отзыв только на полученные товары"
      return
    end

    @review = current_user.reviews.build(review_params.merge(product: @product))

    if @review.save
      redirect_to product_path(@product), notice: "Отзыв добавлен"
    else
      redirect_to product_path(@product), alert: @review.errors.full_messages.join(", ")
    end
  end

  def destroy
    @review = current_user.reviews.find(params[:id])
    @review.destroy
    redirect_to product_path(@review.product), notice: "Отзыв удалён"
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
