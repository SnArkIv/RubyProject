class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty, only: [ :new, :create ]

  def index
    @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
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
    @order = current_user.orders.build(order_params.except(:promo_code))
    @order.status = :pending
    @order.shipping_address = "Самовывоз" if @order.delivery_method == "pickup" && @order.shipping_address.blank?

    @cart_items.each do |item|
      unless item.product.in_stock && item.product.stock_quantity >= item.quantity
        redirect_to cart_path, alert: "Товар «#{item.product.name}» больше нет в наличии в нужном количестве"
        return
      end
    end

    base_amount = @cart_items.sum { |item| item.product.final_price * item.quantity }
    @promo_code_record = find_promo(order_params[:promo_code])
    @order.total_amount = apply_promo(base_amount, @promo_code_record)

    if @order.save
      @promo_code_record&.use!
      @cart_items.each do |item|
        @order.order_items.create!(
          product: item.product,
          size: item.size,
          quantity: item.quantity,
          price: item.product.final_price
        )
                new_stock = [item.product.stock_quantity - item.quantity, 0].max
        item.product.update_columns(stock_quantity: new_stock, in_stock: new_stock > 0)
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
    params.require(:order).permit(:shipping_address, :delivery_method, :payment_method, :promo_code)
  end

  def find_promo(code)
    return nil if code.blank?
    PromoCode.active.find_by(code: code)
  end

  def apply_promo(amount, promo)
    return amount if promo.nil? || !promo.valid_for_use?
    amount * (1 - promo.discount / 100.0)
  end
end
