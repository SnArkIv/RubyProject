json.favorites @favorites do |favorite|
  json.id favorite.id
  json.product do
    json.id favorite.product.id
    json.name favorite.product.name
    json.price favorite.product.price
    json.final_price favorite.product.final_price
    json.image_url favorite.product.images.attached? ? url_for(favorite.product.images.first) : nil
    json.category favorite.product.category&.name
    json.brand favorite.product.brand&.name
  end
end
