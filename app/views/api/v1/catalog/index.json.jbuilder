json.products @products do |product|
  json.id product.id
  json.name product.name
  json.price product.price
  json.final_price product.final_price
  json.discount product.discount
  json.sku product.sku
  json.status product.status
  json.in_stock product.in_stock
  json.color product.color
  json.sizes product.sizes
  json.stock_quantity product.stock_quantity
  json.image_url product.images.attached? ? url_for(product.images.first) : nil
  json.category product.category&.name
  json.brand product.brand&.name
  json.average_rating product.average_rating
end

json.pagination do
  json.count @pagy.count
  json.page @pagy.page
  json.pages @pagy.pages
end

json.filters do
  json.categories @categories do |cat|
    json.id cat.id
    json.name cat.name
  end
  json.brands @brands do |br|
    json.id br.id
    json.name br.name
  end
  json.colors @colors
  json.sizes @sizes
end
