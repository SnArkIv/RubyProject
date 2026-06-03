class Admin::OrdersController < Admin::BaseController
  def index
    scope = Order.includes(:user, order_items: :product).order(created_at: :desc)
    scope = scope.where(status: params[:status]) if params[:status].present?
    if params[:q].present?
      q = "%#{params[:q]}%"
      scope = scope.joins(:user).where("orders.id::text ILIKE ? OR users.email ILIKE ?", q, q)
    end
    @pagy, @orders = pagy(scope, items: 20)
  end

  def show
    @order = Order.includes(order_items: { product: { images_attachments: :blob } }).find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    was_cancelled = @order.status == "cancelled"
    new_status = params[:order][:status]

    if @order.update(order_params)
      if !was_cancelled && new_status == "cancelled"
        @order.order_items.each do |item|
          new_stock = item.product.stock_quantity + item.quantity
          item.product.update_columns(stock_quantity: new_stock, in_stock: new_stock > 0)
        end
      end
      redirect_to admin_order_path(@order), notice: "Статус заказа обновлён"
    else
      redirect_to admin_order_path(@order), alert: "Не удалось обновить статус"
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
