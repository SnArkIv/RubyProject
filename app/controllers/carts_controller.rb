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

    cart_item = @cart.cart_items.find_by(product_id: product.id, size: size)

    if cart_item
      cart_item.update!(quantity: cart_item.quantity + 1)
    else
      @cart.cart_items.create!(product: product, size: size, quantity: 1)
    end

    redirect_back fallback_location: catalog_path, notice: "Товар добавлен в корзину"
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

    redirect_to cart_path, notice: "Корзина обновлена"
  end

  def remove_item
    @cart = current_cart
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy

    redirect_to cart_path, notice: "Товар удалён из корзины"
  end
end
