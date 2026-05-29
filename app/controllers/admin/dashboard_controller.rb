class Admin::DashboardController < Admin::BaseController
  def index
    @total_revenue = Order.where(status: :delivered).sum(:total_amount)
    @orders_count = Order.count
    @orders_by_status = Order.group(:status).count
    @top_products = Product.joins(:order_items)
                           .select("products.*, SUM(order_items.quantity) as sold_count")
                           .group("products.id")
                           .order("sold_count DESC")
                           .limit(10)
    @users_count = User.count
    @products_count = Product.count
  end
end
