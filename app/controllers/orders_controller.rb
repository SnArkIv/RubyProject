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
    default_addr = current_user.addresses.find_by(is_default: true)
    @order = Order.new(
      shipping_address: default_addr ? [default_addr.city, default_addr.street, default_addr.house, default_addr.apartment, default_addr.zip_code].compact.join(", ") : ""
    )
    @addresses = current_user.addresses.order(is_default: :desc, created_at: :desc)
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.status = :pending
    @order.shipping_address = "Самовывоз" if @order.delivery_method == "pickup" && @order.shipping_address.blank?

    cart_items = @cart_items
    if params[:single_item_id].present?
      cart_items = cart_items.where(id: params[:single_item_id])
    end

    if cart_items.empty?
      redirect_to cart_path, alert: "Корзина пуста"
      return
    end

    cart_items.each do |item|
      unless item.product.in_stock_for_size?(item.size) && item.product.stock_for_size(item.size) >= item.quantity
        redirect_to cart_path, alert: "Товар «#{item.product.name}» (#{item.size}) больше нет в наличии в нужном количестве"
        return
      end
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
                new_stock = [item.product.stock_for_size(item.size) - item.quantity, 0].max
        new_stock_by_size = (item.product.stock_by_size || {}).merge(item.size => new_stock)
        total = new_stock_by_size.values.sum(&:to_i)
        item.product.update_columns(stock_by_size: new_stock_by_size, stock_quantity: total, in_stock: total > 0)
      end

      cart_items.destroy_all
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

    if params[:from_cart].present? && params[:cart_item_ids].blank?
      redirect_to cart_path, alert: "Выберите товары для заказа."
      return
    end

    if params[:cart_item_ids].present?
      @cart_items = @cart_items.where(id: params[:cart_item_ids])
    end

    if @cart_items.empty?
      redirect_to cart_path, alert: "Корзина пуста. Выберите товары для заказа."
    end
  end

  def order_params
    if params[:order].present?
      params.require(:order).permit(:shipping_address, :delivery_method, :payment_method)
    elsif params[:single_item_id].present?
      ActionController::Parameters.new(
        shipping_address: "Самовывоз", delivery_method: "pickup", payment_method: "cash"
      ).permit!
    else
      params.require(:order).permit(:shipping_address, :delivery_method, :payment_method)
    end
  end
end
