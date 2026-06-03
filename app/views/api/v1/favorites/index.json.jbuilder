json.favorites @favorites do |favorite|
  json.id favorite.product.id
  json.name favorite.product.name
  json.price favorite.product.price
  json.final_price favorite.product.final_price
  json.discount favorite.product.discount
  json.image_url favorite.product.images.attached? ? url_for(favorite.product.images.first) : nil
end