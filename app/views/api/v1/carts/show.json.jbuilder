json.cart do
  json.id @cart.id
  json.items @cart_items do |item|
    json.id item.id
    json.quantity item.quantity
    json.size item.size
    json.product do
      json.id item.product.id
      json.name item.product.name
      json.price item.product.price
      json.final_price item.product.final_price
      json.image_url item.product.images.attached? ? url_for(item.product.images.first) : nil
    end
  end
  json.total_amount @cart.total_amount
  json.items_count @cart.items_count
end
