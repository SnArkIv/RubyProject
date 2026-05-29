class PagesController < ApplicationController
  def about
    @categories = Category.order(:name).limit(6)
    @sale_products = Product.published.on_sale.in_stock.order(discount: :desc).limit(8)
  end
end
