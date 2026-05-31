require "open-uri"

# Clean up
User.destroy_all
Product.destroy_all
Category.destroy_all
Brand.destroy_all
Cart.destroy_all
Order.destroy_all
Review.destroy_all
Address.destroy_all
Favorite.destroy_all

# Users
admin = User.create!(
  email: "admin@example.com",
  password: "admin123",
  password_confirmation: "admin123",
  role: :admin
)

manager = User.create!(
  email: "manager@example.com",
  password: "manager123",
  password_confirmation: "manager123",
  role: :manager
)

customers = 3.times.map do |i|
  User.create!(
    email: "customer#{i + 1}@example.com",
    password: "password12",
    password_confirmation: "password12",
    role: :customer
  )
end

# Categories
category_tshirts = Category.create!(name: "Футболки")
category_jeans = Category.create!(name: "Джинсы")
category_jackets = Category.create!(name: "Куртки")

# Brands
brand_forestwalk = Brand.create!(name: "ForestWalk")
brand_denimpro = Brand.create!(name: "DenimPro")
brand_windshield = Brand.create!(name: "WindShield")
brand_basicline = Brand.create!(name: "BasicLine")
brand_classicfit = Brand.create!(name: "ClassicFit")
brand_leathercraft = Brand.create!(name: "LeatherCraft")

ITEMS = [
  {
    name: "Футболка оверсайз Шрек",
    description: "Свободный крой, 100% хлопок. Принт устойчив к стиркам.",
    price: 2_990,
    discount: 25,
    stock_quantity: 12,
    sku: "FW-TSH-001",
    category: category_tshirts,
    brand: brand_forestwalk,
    gender: "male",
    sizes: %w[S M L XL],
    material: "100% хлопок",
    color: "Зелёный",
    care_instructions: "Стирать при 30°C, не отбеливать",
    img: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы классика",
    description: "Прямой крой, плотный деним. Универсальная модель на каждый день.",
    price: 5_490,
    discount: 0,
    stock_quantity: 34,
    sku: "DP-JNS-001",
    category: category_jeans,
    brand: brand_denimpro,
    gender: "all",
    sizes: %w[30 32 34 36],
    material: "98% хлопок, 2% эластан",
    color: "Тёмно-синий",
    care_instructions: "Стирать при 40°C, сушить в расправленном виде",
    img: "https://images.unsplash.com/photo-1542272604-787c3835535d?w=600&h=600&fit=crop"
  },
  {
    name: "Куртка ветровка",
    description: "Лёгкая непродуваемая ткань с водоотталкивающей пропиткой.",
    price: 7_990,
    discount: 20,
    stock_quantity: 3,
    sku: "WS-JCK-001",
    category: category_jackets,
    brand: brand_windshield,
    gender: "female",
    sizes: %w[XS S M L],
    material: "Нейлон",
    color: "Бежевый",
    care_instructions: "Стирать при 30°C, не гладить",
    img: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка базовая белая",
    description: "Белая база на каждый день. Мягкая ткань, удобный крой.",
    price: 1_490,
    discount: 25,
    stock_quantity: 120,
    sku: "BL-TSH-001",
    category: category_tshirts,
    brand: brand_basicline,
    gender: "female",
    sizes: %w[XS S M L XL],
    material: "100% хлопок",
    color: "Белый",
    care_instructions: "Стирать при 40°C",
    img: "https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы скинни",
    description: "Эластичная ткань, комфортная посадка. Подчёркивает фигуру.",
    price: 4_990,
    discount: 0,
    stock_quantity: 45,
    sku: "DP-JNS-002",
    category: category_jeans,
    brand: brand_denimpro,
    gender: "female",
    sizes: %w[26 28 30 32],
    material: "92% хлопок, 6% эластан, 2% полиэстер",
    color: "Чёрный",
    care_instructions: "Стирать при 30°C, не сушить в машине",
    img: "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=600&h=600&fit=crop"
  },
  {
    name: "Куртка демисезон",
    description: "Утеплитель, капюшон, защита от влаги. Идеальна для межсезонья.",
    price: 11_990,
    discount: 20,
    stock_quantity: 7,
    sku: "FW-JCK-001",
    category: category_jackets,
    brand: brand_forestwalk,
    gender: "male",
    sizes: %w[M L XL XXL],
    material: "Полиэстер с мембраной",
    color: "Хаки",
    care_instructions: "Сухая чистка или стирка при 30°C",
    img: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка поло",
    description: "Классический крой с воротником. Подходит для повседневного и делового стиля.",
    price: 3_290,
    discount: 0,
    stock_quantity: 200,
    sku: "CF-TSH-001",
    category: category_tshirts,
    brand: brand_classicfit,
    gender: "male",
    sizes: %w[S M L XL XXL],
    material: "100% хлопок пике",
    color: "Тёмно-синий",
    care_instructions: "Стирать при 40°C, гладить при низкой температуре",
    img: "https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы mom fit",
    description: "Высокая посадка, свободный крой. Винтажный стиль и комфорт.",
    price: 5_990,
    discount: 14,
    stock_quantity: 28,
    sku: "DP-JNS-003",
    category: category_jeans,
    brand: brand_denimpro,
    gender: "female",
    sizes: %w[26 28 30 32 34],
    material: "100% хлопок",
    color: "Голубой",
    care_instructions: "Стирать при 30°C, избегать машинной сушки",
    img: "https://images.unsplash.com/photo-1584370848010-d7cc637070f6?w=600&h=600&fit=crop"
  },
  {
    name: "Куртка кожаная",
    description: "Натуральная кожа, классический силуэт. Вечный тренд.",
    price: 18_990,
    discount: 17,
    stock_quantity: 0,
    sku: "LC-JCK-001",
    category: category_jackets,
    brand: brand_leathercraft,
    gender: "male",
    sizes: %w[S M L XL],
    material: "Натуральная кожа",
    color: "Чёрный",
    care_instructions: "Чистка в специализированных сервисах",
    img: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка оверсайз женская",
    description: "Свободный крой, удлинённая спина. Минималистичный дизайн.",
    price: 2_190,
    discount: 0,
    stock_quantity: 75,
    sku: "BL-TSH-002",
    category: category_tshirts,
    brand: brand_basicline,
    gender: "female",
    sizes: %w[XS S M L],
    material: "100% хлопок",
    color: "Песочный",
    care_instructions: "Стирать при 30°C",
    img: "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы прямые мужские",
    description: "Классический прямой крой без утяжки. Универсальный базовый элемент гардероба.",
    price: 4_790,
    discount: 13,
    stock_quantity: 18,
    sku: "DP-JNS-004",
    category: category_jeans,
    brand: brand_denimpro,
    gender: "male",
    sizes: %w[30 32 34 36 38],
    material: "99% хлопок, 1% эластан",
    color: "Индиго",
    care_instructions: "Стирать при 40°C, гладить при средней температуре",
    img: "https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?w=600&h=600&fit=crop"
  },
  {
    name: "Куртка бомбер",
    description: "Стильный бомбер с контрастной отделкой. Подходит для прохладной погоды.",
    price: 8_490,
    discount: 0,
    stock_quantity: 42,
    sku: "WS-JCK-002",
    category: category_jackets,
    brand: brand_windshield,
    gender: "all",
    sizes: %w[XS S M L XL],
    material: "Полиэстер",
    color: "Тёмно-зелёный",
    care_instructions: "Стирать при 30°C, не отбеливать",
    img: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&h=600&fit=crop"
  }
].freeze

ITEMS.each do |attrs|
  img = attrs.delete(:img)
  category = attrs.delete(:category)
  brand = attrs.delete(:brand)
  p = Product.create!(
    attrs.merge(
      category_id: category.id,
      brand_id: brand.id,
      status: :published,
      in_stock: true
    )
  )
  begin
    p.images.attach(
      io: URI.open(img, open_timeout: 5, read_timeout: 5),
      filename: "#{p.sku}.jpg"
    )
  rescue OpenURI::HTTPError, SocketError, Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout => e
    Rails.logger.warn "Failed to load image for #{p.name}: #{e.message}"
    # Skip image attachment when network is unavailable
  end
end

# Create some orders and reviews for demo analytics
product_ids = Product.pluck(:id)

customers.each do |customer|
  cart = customer.create_cart!(session_token: SecureRandom.hex(16))
  sample_products = Product.where(id: product_ids.sample(2))
  sample_products.each do |prd|
    cart.cart_items.create!(product: prd, size: prd.sizes.sample, quantity: rand(1..2))
  end

  order = customer.orders.create!(
    shipping_address: "г. Москва, ул. Примерная, д. 1, кв. 10, 123456",
    total_amount: 0,
    status: :delivered,
    delivery_method: "courier",
    payment_method: "card_on_delivery"
  )
  cart.cart_items.each do |item|
    order.order_items.create!(
      product: item.product,
      size: item.size,
      quantity: item.quantity,
      price: item.product.final_price
    )
  end
  order.update!(total_amount: order.order_items.sum { |oi| oi.price * oi.quantity })
  cart.cart_items.destroy_all

  # Add a review on one product
  Review.create!(
    user: customer,
    product: sample_products.first,
    rating: rand(3..5),
    comment: "Отличный товар, качество на высоте."
  )
end

puts "Seeds completed: #{User.count} users, #{Category.count} categories, #{Brand.count} brands, #{Product.count} products, #{Order.count} orders, #{Review.count} reviews."
