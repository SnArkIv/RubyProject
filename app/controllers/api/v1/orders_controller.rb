module Api
  module V1
    class OrdersController < BaseController
      def index
        @orders = current_user.orders.includes(order_items: :product).order(created_at: :desc)
      end

      def show
        @order = current_user.orders.find(params[:id])
      end

      def create
        @order = current_user.orders.build(order_params)
        @order.status = :pending
        @order.shipping_address = "Самовывоз" if @order.delivery_method == "pickup" && @order.shipping_address.blank?
        cart = current_cart
        cart_items = cart.cart_items.includes(:product)

        if cart_items.empty?
          return render json: { error: "Корзина пуста" }, status: :unprocessable_entity
        end

        @order.total_amount = cart_items.sum { |item| item.product.final_price * item.quantity }

        if @order.save
          cart_items.each do |item|
            @order.order_items.create!(
              product: item.product,
              size: item.size,
              quantity: item.quantity,
              price: item.product.final_price
            )
            new_stock = [item.product.stock_quantity - item.quantity, 0].max
            item.product.update_columns(stock_quantity: new_stock, in_stock: new_stock > 0)
          end
          cart.cart_items.destroy_all
          OrderMailer.confirmation(@order).deliver_later
          OrderMailer.notify_admin(@order).deliver_later
          render json: { order: @order.as_json(include: :order_items), message: "Заказ оформлен" }, status: :created
        else
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def repeat
        @order = current_user.orders.find(params[:id])
        cart = current_cart

        @order.order_items.each do |item|
          existing = cart.cart_items.find_by(product_id: item.product_id, size: item.size)
          if existing
            existing.update!(quantity: existing.quantity + item.quantity)
          else
            cart.cart_items.create!(product: item.product, size: item.size, quantity: item.quantity)
          end
        end

        render json: { message: "Товары добавлены в корзину" }
      end

      private

      def order_params
        params.require(:order).permit(:shipping_address, :delivery_method, :payment_method)
      end
    end
  end
end
