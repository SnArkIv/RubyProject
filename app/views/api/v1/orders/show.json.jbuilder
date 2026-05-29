json.id @order.id
json.status @order.status
json.total_amount @order.total_amount
json.shipping_address @order.shipping_address
json.delivery_method @order.delivery_method
json.payment_method @order.payment_method
json.created_at @order.created_at
json.order_items @order.order_items do |item|
  json.id item.id
  json.quantity item.quantity
  json.price item.price
  json.size item.size
  json.product do
    json.id item.product.id
    json.name item.product.name
    json.image_url item.product.images.attached? ? url_for(item.product.images.first) : nil
  end
end
