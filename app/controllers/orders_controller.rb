class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty, only: [ :new, :create ]

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
    @order_items = @order.order_items.includes(product: { images_attachments: :blob })
  end

  def new
    @order = Order.new
    @addresses = current_user.addresses.order(is_default: :desc, created_at: :desc)
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.status = :pending
    @order.total_amount = @cart_items.sum { |item| item.product.final_price * item.quantity }

    if @order.save
      @cart_items.each do |item|
        @order.order_items.create!(
          product: item.product,
          size: item.size,
          quantity: item.quantity,
          price: item.product.final_price
        )
      end

      current_cart.cart_items.destroy_all
      OrderMailer.confirmation(@order).deliver_later
      OrderMailer.notify_admin(@order).deliver_later
      redirect_to order_path(@order), notice: "Заказ успешно оформлен"
    else
      @addresses = current_user.addresses.order(is_default: :desc, created_at: :desc)
      render :new, status: :unprocessable_entity
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

    redirect_to cart_path, notice: "Товары из заказа добавлены в корзину"
  end

  private

  def ensure_cart_not_empty
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(product: { images_attachments: :blob })

    if @cart_items.empty?
      redirect_to cart_path, alert: "Корзина пуста. Добавьте товары перед оформлением заказа."
    end
  end

  def order_params
    params.require(:order).permit(:shipping_address, :delivery_method, :payment_method)
  end
end
