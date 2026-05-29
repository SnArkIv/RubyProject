json.orders @orders do |order|
  json.id order.id
  json.status order.status
  json.total_amount order.total_amount
  json.shipping_address order.shipping_address
  json.delivery_method order.delivery_method
  json.payment_method order.payment_method
  json.created_at order.created_at
end
