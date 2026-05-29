json.categories @categories do |category|
  json.id category.id
  json.name category.name
  json.products_count category.products.published.count
end
