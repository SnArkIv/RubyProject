class Admin::OrdersController < Admin::BaseController
  def index
    scope = Order.includes(:user, order_items: :product).order(created_at: :desc)
    scope = scope.where(status: params[:status]) if params[:status].present?
    @pagy, @orders = pagy(scope, items: 20)
  end

  def show
    @order = Order.includes(order_items: { product: { images_attachments: :blob } }).find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
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
