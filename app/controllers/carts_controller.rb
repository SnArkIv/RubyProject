class CartsController < ApplicationController
  def show
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(product: { images_attachments: :blob })
  end

  def add_item
    @cart = current_cart
    product = Product.find(params[:product_id])
    size = params[:size].to_s.strip

    if size.blank?
      redirect_back fallback_location: catalog_path, alert: "Выберите размер"
      return
    end

    unless product.in_stock
      redirect_back fallback_location: catalog_path, alert: "Товара нет в наличии"
      return
    end

    available = product.stock_for_size(size)
    if available <= 0
      redirect_back fallback_location: catalog_path, alert: "Размера «#{size}» нет в наличии"
      return
    end

    cart_item = @cart.cart_items.find_by(product_id: product.id, size: size)
    current_qty = cart_item ? cart_item.quantity : 0

    if current_qty >= available
      redirect_back fallback_location: catalog_path, alert: "Недостаточно товара на складе (доступно: #{available} шт.)"
      return
    end

    if cart_item
      cart_item.update!(quantity: current_qty + 1)
    else
      @cart.cart_items.create!(product: product, size: size, quantity: 1)
    end

    redirect_back fallback_location: catalog_path, notice: "Товар добавлен в корзину"
  end

  def update_item
    @cart = current_cart
    cart_item = @cart.cart_items.find_by(id: params[:id])
    unless cart_item
      respond_to do |format|
        format.html { redirect_to cart_path, alert: "Товар не найден" }
        format.json { render json: { error: "Товар не найден" }, status: :not_found }
      end
      return
    end

    quantity = params[:quantity].to_i
    available = cart_item.product.stock_for_size(cart_item.size)

    if quantity > available
      respond_to do |format|
        format.html { redirect_to cart_path, alert: "Недостаточно товара на складе (доступно: #{available} шт.)" }
        format.json { render json: { error: "Недостаточно товара (доступно: #{available})" }, status: :unprocessable_entity }
      end
      return
    end

    if quantity > 0
      cart_item.update!(quantity: quantity)
    else
      cart_item.destroy
    end

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Корзина обновлена" }
      format.json do
        @cart_items = current_cart.reload.cart_items.includes(:product)
        render json: {
          item_total: (cart_item.persisted? ? cart_item.product.final_price * cart_item.quantity : 0).round,
          item_id: cart_item.id,
          quantity: cart_item.persisted? ? cart_item.quantity : 0,
          cart_total: @cart_items.sum { |ci| ci.product.final_price * ci.quantity }.round,
          item_count: @cart_items.count
        }
      end
    end
  end

  def remove_item
    @cart = current_cart
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy

    redirect_to cart_path, notice: "Товар удалён из корзины"
  end
end
