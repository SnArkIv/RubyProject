class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites.includes(product: [ :category, :brand, { images_attachments: :blob } ])
  end

  def create
    @product = Product.find(params[:product_id])
    current_user.favorites.create!(product: @product)
    redirect_back fallback_location: catalog_path, notice: "Добавлено в избранное"
  rescue ActiveRecord::RecordInvalid
    redirect_back fallback_location: catalog_path, alert: "Уже в избранном"
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy
    redirect_back fallback_location: catalog_path, notice: "Удалено из избранного"
  end
end
