json.id @product.id
json.name @product.name
json.description @product.description
json.price @product.price
json.final_price @product.final_price
json.discount @product.discount
json.sku @product.sku
json.status @product.status
json.in_stock @product.in_stock
json.color @product.color
json.material @product.material
json.sizes @product.sizes
json.care_instructions @product.care_instructions
json.gender @product.gender
json.average_rating @product.average_rating
json.category @product.category&.name
json.brand @product.brand&.name
json.images @product.images.map { |img| url_for(img) }

json.similar_products @similar_products do |product|
  json.id product.id
  json.name product.name
  json.final_price product.final_price
  json.image_url product.images.attached? ? url_for(product.images.first) : nil
end

json.reviews @reviews do |review|
  json.id review.id
  json.rating review.rating
  json.comment review.comment
  json.user_email review.user.email
  json.created_at review.created_at
end
