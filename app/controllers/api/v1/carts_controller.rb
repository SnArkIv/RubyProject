module Api
  module V1
    class CartsController < BaseController
      skip_before_action :authenticate_user!, only: [ :show, :add_item, :update_item, :remove_item ]

      def show
        @cart = current_cart
        @cart_items = @cart.cart_items.includes(product: { images_attachments: :blob })
      end

      def add_item
        @cart = current_cart
        product = Product.find(params[:product_id])
        size = params[:size].to_s.strip

        return render json: { error: "Выберите размер" }, status: :unprocessable_entity if size.blank?

        cart_item = @cart.cart_items.find_by(product_id: product.id, size: size)
        if cart_item
          cart_item.update!(quantity: cart_item.quantity + 1)
        else
          @cart.cart_items.create!(product: product, size: size, quantity: 1)
        end

        render json: { message: "Товар добавлен в корзину", cart: cart_json }
      end

      def update_item
        @cart = current_cart
        cart_item = @cart.cart_items.find(params[:id])
        quantity = params[:quantity].to_i

        if quantity > 0
          cart_item.update!(quantity: quantity)
        else
          cart_item.destroy
        end

        render json: { message: "Корзина обновлена", cart: cart_json }
      end

      def remove_item
        @cart = current_cart
        cart_item = @cart.cart_items.find(params[:id])
        cart_item.destroy
        render json: { message: "Товар удалён из корзины", cart: cart_json }
      end

      private

      def cart_json
        @cart = current_cart
        {
          items: @cart.cart_items.map do |item|
            {
              id: item.id,
              product: {
                id: item.product.id,
                name: item.product.name,
                final_price: item.product.final_price,
                image_url: item.product.images.attached? ? url_for(item.product.images.first) : nil
              },
              size: item.size,
              quantity: item.quantity
            }
          end,
          total_amount: @cart.total_amount,
          items_count: @cart.items_count
        }
      end
    end
  end
end
