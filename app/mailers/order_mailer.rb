class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @order_items = @order.order_items.includes(:product)
    mail(to: @order.user.email, subject: "Подтверждение заказа №#{@order.id}")
  end

  def notify_admin(order)
    @order = order
    @order_items = @order.order_items.includes(:product)
    mail(to: "admin@example.com", subject: "Новый заказ №#{@order.id}")
  end
end
