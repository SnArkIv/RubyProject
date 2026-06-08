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
categories = {}
%w[Футболки Джинсы Куртки Платья Рубашки Толстовки Шорты Пальто Аксессуары].each do |name|
  categories[name.downcase.to_sym] = Category.create!(name: name)
end

# Brands
brands = {}
[
  "ForestWalk", "DenimPro", "WindShield", "BasicLine", "ClassicFit", "LeatherCraft",
  "UrbanEdge", "NordicWool", "SummerBreeze", "StreetCode", "Elegance", "SportMaster"
].each do |name|
  brands[name.downcase.to_sym] = Brand.create!(name: name)
end

ITEMS = [
  # === Футболки ===
  {
    name: "Футболка оверсайз Шрек",
    description: "Свободный крой, 100% хлопок. Принт устойчив к стиркам.",
    price: 2_990, discount: 25, stock_quantity: 12,
    sku: "FW-TSH-001", category: categories[:футболки], brand: brands[:forestwalk],
    gender: "male", sizes: %w[S M L XL], material: "100% хлопок", color: "Зелёный",
    care_instructions: "Стирать при 30°C, не отбеливать",
    img: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка базовая белая",
    description: "Белая база на каждый день. Мягкая ткань, удобный крой.",
    price: 1_490, discount: 25, stock_quantity: 120,
    sku: "BL-TSH-001", category: categories[:футболки], brand: brands[:basicline],
    gender: "female", sizes: %w[XS S M L XL], material: "100% хлопок", color: "Белый",
    care_instructions: "Стирать при 40°C",
    img: "https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка поло",
    description: "Классический крой с воротником. Для повседневного и делового стиля.",
    price: 3_290, discount: 0, stock_quantity: 200,
    sku: "CF-TSH-001", category: categories[:футболки], brand: brands[:classicfit],
    gender: "male", sizes: %w[S M L XL XXL], material: "100% хлопок пике", color: "Тёмно-синий",
    care_instructions: "Стирать при 40°C, гладить при низкой температуре",
    img: "https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка оверсайз женская",
    description: "Свободный крой, удлинённая спина. Минималистичный дизайн.",
    price: 2_190, discount: 0, stock_quantity: 75,
    sku: "BL-TSH-002", category: categories[:футболки], brand: brands[:basicline],
    gender: "female", sizes: %w[XS S M L], material: "100% хлопок", color: "Песочный",
    care_instructions: "Стирать при 30°C",
    img: "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка с принтом City",
    description: "Яркий принт, свободный крой. Для смелых образов.",
    price: 2_490, discount: 10, stock_quantity: 55,
    sku: "UE-TSH-001", category: categories[:футболки], brand: brands[:urbanedge],
    gender: "unisex", sizes: %w[S M L XL], material: "95% хлопок, 5% эластан", color: "Чёрный",
    care_instructions: "Стирать при 30°C, не отбеливать",
    img: "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка поло женская",
    description: "Приталенный крой, мягкая ткань. Идеально для офиса и прогулок.",
    price: 3_490, discount: 0, stock_quantity: 0,
    sku: "CF-TSH-002", category: categories[:футболки], brand: brands[:classicfit],
    gender: "female", sizes: %w[XS S M], material: "100% хлопок пике", color: "Бордовый",
    care_instructions: "Стирать при 30°C, гладить с изнанки",
    img: "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка лонгслив",
    description: "Удлинённый рукав, плотный хлопок. Базовая вещь на прохладную погоду.",
    price: 2_690, discount: 0, stock_quantity: 8,
    sku: "FW-TSH-002", category: categories[:футболки], brand: brands[:forestwalk],
    gender: "male", sizes: %w[M L XL XXL], material: "100% хлопок", color: "Серый меланж",
    care_instructions: "Стирать при 30°C",
    img: "https://images.unsplash.com/photo-1622445275463-afa2ab738c34?w=600&h=600&fit=crop"
  },
  {
    name: "Футболка с вышивкой",
    description: "Льняная футболка с декоративной вышивкой. Эко-стиль.",
    price: 3_990, discount: 15, stock_quantity: 22,
    sku: "SB-TSH-001", category: categories[:футболки], brand: brands[:summerbreeze],
    gender: "female", sizes: %w[XS S M], material: "100% лён", color: "Бежевый",
    care_instructions: "Стирать при 30°C, не отжимать",
    img: "https://images.unsplash.com/photo-1562157873-818bc0726f68?w=600&h=600&fit=crop"
  },

  # === Джинсы ===
  {
    name: "Джинсы классика",
    description: "Прямой крой, плотный деним. Универсальная модель на каждый день.",
    price: 5_490, discount: 0, stock_quantity: 34,
    sku: "DP-JNS-001", category: categories[:джинсы], brand: brands[:denimpro],
    gender: "all", sizes: %w[30 32 34 36], material: "98% хлопок, 2% эластан", color: "Тёмно-синий",
    care_instructions: "Стирать при 40°C, сушить в расправленном виде",
    img: "https://images.unsplash.com/photo-1542272604-787c3835535d?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы скинни",
    description: "Эластичная ткань, комфортная посадка. Подчёркивает фигуру.",
    price: 4_990, discount: 0, stock_quantity: 45,
    sku: "DP-JNS-002", category: categories[:джинсы], brand: brands[:denimpro],
    gender: "female", sizes: %w[26 28 30 32], material: "92% хлопок, 6% эластан, 2% полиэстер", color: "Чёрный",
    care_instructions: "Стирать при 30°C, не сушить в машине",
    img: "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы mom fit",
    description: "Высокая посадка, свободный крой. Винтажный стиль и комфорт.",
    price: 5_990, discount: 14, stock_quantity: 28,
    sku: "DP-JNS-003", category: categories[:джинсы], brand: brands[:denimpro],
    gender: "female", sizes: %w[26 28 30 32 34], material: "100% хлопок", color: "Голубой",
    care_instructions: "Стирать при 30°C, избегать машинной сушки",
    img: "https://images.unsplash.com/photo-1584370848010-d7cc637070f6?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы прямые мужские",
    description: "Классический прямой крой без утяжки. Базовый элемент гардероба.",
    price: 4_790, discount: 13, stock_quantity: 18,
    sku: "DP-JNS-004", category: categories[:джинсы], brand: brands[:denimpro],
    gender: "male", sizes: %w[30 32 34 36 38], material: "99% хлопок, 1% эластан", color: "Индиго",
    care_instructions: "Стирать при 40°C, гладить при средней температуре",
    img: "https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы boyfriend",
    description: "Свободные, с потёртостями. Небрежный стиль.",
    price: 5_290, discount: 0, stock_quantity: 0,
    sku: "DP-JNS-005", category: categories[:джинсы], brand: brands[:denimpro],
    gender: "female", sizes: %w[28 30 32], material: "100% хлопок", color: "Светло-голубой",
    care_instructions: "Стирать при 30°C",
    img: "https://images.unsplash.com/photo-1593030103066-0093718ef1c9?w=600&h=600&fit=crop"
  },
  {
    name: "Джинсы карго",
    description: "Свободный крой, накладные карманы. Для активного отдыха.",
    price: 6_490, discount: 10, stock_quantity: 15,
    sku: "SC-JNS-001", category: categories[:джинсы], brand: brands[:streetcode],
    gender: "male", sizes: %w[30 32 34 36], material: "100% хлопок", color: "Оливковый",
    care_instructions: "Стирать при 40°C",
    img: "https://images.unsplash.com/photo-1604176354204-9268737828e4?w=600&h=600&fit=crop"
  },

  # === Куртки ===
  {
    name: "Куртка ветровка",
    description: "Лёгкая непродуваемая ткань с водоотталкивающей пропиткой.",
    price: 7_990, discount: 20, stock_quantity: 3,
    sku: "WS-JCK-001", category: categories[:куртки], brand: brands[:windshield],
    gender: "female", sizes: %w[XS S M L], material: "Нейлон", color: "Бежевый",
    care_instructions: "Стирать при 30°C, не гладить",
    img: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&h=600&fit=crop"
  },
  {
    name: "Куртка демисезон",
    description: "Утеплитель, капюшон, защита от влаги. Идеальна для межсезонья.",
    price: 11_990, discount: 20, stock_quantity: 7,
    sku: "FW-JCK-001", category: categories[:куртки], brand: brands[:forestwalk],
    gender: "male", sizes: %w[M L XL XXL], material: "Полиэстер с мембраной", color: "Хаки",
    care_instructions: "Сухая чистка или стирка при 30°C",
    img: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&h=600&fit=crop"
  },
  {
    name: "Куртка кожаная",
    description: "Натуральная кожа, классический силуэт. Вечный тренд.",
    price: 18_990, discount: 17, stock_quantity: 0,
    sku: "LC-JCK-001", category: categories[:куртки], brand: brands[:leathercraft],
    gender: "male", sizes: %w[S M L XL], material: "Натуральная кожа", color: "Чёрный",
    care_instructions: "Чистка в специализированных сервисах",
    img: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&h=600&fit=crop"
  },
  {
    name: "Куртка бомбер",
    description: "Стильный бомбер с контрастной отделкой. Для прохладной погоды.",
    price: 8_490, discount: 0, stock_quantity: 42,
    sku: "WS-JCK-002", category: categories[:куртки], brand: brands[:windshield],
    gender: "all", sizes: %w[XS S M L XL], material: "Полиэстер", color: "Тёмно-зелёный",
    care_instructions: "Стирать при 30°C, не отбеливать",
    img: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&h=600&fit=crop"
  },
  {
    name: "Пальто шерстяное",
    description: "Классическое пальто из шерсти. Двубортный силуэт.",
    price: 24_990, discount: 0, stock_quantity: 6,
    sku: "NW-OVR-001", category: categories[:куртки], brand: brands[:nordicwool],
    gender: "male", sizes: %w[M L XL], material: "80% шерсть, 20% полиамид", color: "Тёмно-серый",
    care_instructions: "Только сухая чистка",
    img: "https://images.unsplash.com/photo-1578439231583-9eca0a363860?w=600&h=600&fit=crop"
  },
  {
    name: "Пуховик зимний",
    description: "Тёплый пуховик с капюшоном. Выдерживает до -30°C.",
    price: 15_990, discount: 30, stock_quantity: 10,
    sku: "NW-DWN-001", category: categories[:куртки], brand: brands[:nordicwool],
    gender: "all", sizes: %w[S M L XL XXL], material: "100% полиэстер, наполнитель гусиный пух", color: "Чёрный",
    care_instructions: "Стирка при 30°C, специальный режим",
    img: "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=600&h=600&fit=crop"
  },
  {
    name: "Косуха женская",
    description: "Короткая кожаная куртка с асимметричной молнией. Рок-стиль.",
    price: 14_990, discount: 0, stock_quantity: 20,
    sku: "LC-JCK-002", category: categories[:куртки], brand: brands[:leathercraft],
    gender: "female", sizes: %w[XS S M L], material: "Натуральная кожа", color: "Коричневый",
    care_instructions: "Чистка в специализированных сервисах",
    img: "https://images.unsplash.com/photo-1521225170081-1e0e0e3d5b0b?w=600&h=600&fit=crop"
  },

  # === Платья ===
  {
    name: "Платье-миди приталенное",
    description: "Элегантное платье до колена. Подчёркивает фигуру.",
    price: 6_990, discount: 0, stock_quantity: 25,
    sku: "EG-DRS-001", category: categories[:платья], brand: brands[:elegance],
    gender: "female", sizes: %w[XS S M L], material: "95% полиэстер, 5% эластан", color: "Тёмно-синий",
    care_instructions: "Стирать при 30°C, не отжимать",
    img: "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=600&h=600&fit=crop"
  },
  {
    name: "Сарафан летний",
    description: "Лёгкий сарафан из натурального льна. Дышит в жару.",
    price: 4_490, discount: 20, stock_quantity: 33,
    sku: "SB-DRS-001", category: categories[:платья], brand: brands[:summerbreeze],
    gender: "female", sizes: %w[XS S M L XL], material: "100% лён", color: "Белый",
    care_instructions: "Стирать при 30°C, гладить влажным",
    img: "https://images.unsplash.com/photo-1623609163859-ca93c959b5d8?w=600&h=600&fit=crop"
  },
  {
    name: "Платье коктейльное",
    description: "Короткое платье с открытыми плечами. Для особых случаев.",
    price: 9_990, discount: 0, stock_quantity: 5,
    sku: "EG-DRS-002", category: categories[:платья], brand: brands[:elegance],
    gender: "female", sizes: %w[S M], material: "100% шёлк", color: "Бордовый",
    care_instructions: "Только химчистка",
    img: "https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=600&h=600&fit=crop"
  },

  # === Рубашки ===
  {
    name: "Рубашка классическая белая",
    description: "Офисная рубашка из хлопка. Отличная посадка.",
    price: 3_990, discount: 0, stock_quantity: 100,
    sku: "CF-SHT-001", category: categories[:рубашки], brand: brands[:classicfit],
    gender: "male", sizes: %w[S M L XL XXL], material: "100% хлопок", color: "Белый",
    care_instructions: "Стирать при 40°C, гладить при высокой температуре",
    img: "https://images.unsplash.com/photo-1603252109303-2751441dd157?w=600&h=600&fit=crop"
  },
  {
    name: "Рубашка в клетку",
    description: "Кежуал-рубашка из мягкого хлопка. Клетка \"тартан\".",
    price: 4_490, discount: 0, stock_quantity: 60,
    sku: "FW-SHT-001", category: categories[:рубашки], brand: brands[:forestwalk],
    gender: "male", sizes: %w[M L XL], material: "100% хлопок", color: "Красный",
    care_instructions: "Стирать при 30°C, не отбеливать",
    img: "https://images.unsplash.com/photo-1603073163308-9654c3fb70b5?w=600&h=600&fit=crop"
  },
  {
    name: "Рубашка женская оверсайз",
    description: "Свободная рубашка из хлопка. Можно носить как куртку.",
    price: 4_290, discount: 10, stock_quantity: 35,
    sku: "SB-SHT-001", category: categories[:рубашки], brand: brands[:summerbreeze],
    gender: "female", sizes: %w[XS S M L], material: "100% хлопок", color: "Голубой",
    care_instructions: "Стирать при 30°C",
    img: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&h=600&fit=crop"
  },

  # === Толстовки ===
  {
    name: "Худи оверсайз",
    description: "Тёплое худи с капюшоном. На флисе.",
    price: 4_990, discount: 0, stock_quantity: 80,
    sku: "SC-HDY-001", category: categories[:толстовки], brand: brands[:streetcode],
    gender: "unisex", sizes: %w[S M L XL XXL], material: "80% хлопок, 20% полиэстер", color: "Чёрный",
    care_instructions: "Стирать при 30°C, не отбеливать",
    img: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=600&h=600&fit=crop"
  },
  {
    name: "Кенгурушка с принтом",
    description: "Худи с накладным карманом и ярким принтом.",
    price: 5_490, discount: 15, stock_quantity: 2,
    sku: "UE-HDY-001", category: categories[:толстовки], brand: brands[:urbanedge],
    gender: "male", sizes: %w[M L XL], material: "100% хлопок", color: "Серый",
    care_instructions: "Стирать при 30°C, отбеливать запрещено",
    img: "https://images.unsplash.com/photo-1578768079052-aa76e52ff62e?w=600&h=600&fit=crop"
  },
  {
    name: "Спортивная кофта",
    description: "Кофта из футера с начёсом. Для спорта и отдыха.",
    price: 3_990, discount: 0, stock_quantity: 0,
    sku: "SM-SWT-001", category: categories[:толстовки], brand: brands[:sportmaster],
    gender: "male", sizes: %w[S M L XL XXL], material: "100% хлопок", color: "Тёмно-синий",
    care_instructions: "Стирать при 40°C",
    img: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=600&h=600&fit=crop"
  },

  # === Шорты ===
  {
    name: "Шорты джинсовые",
    description: "Классические джинсовые шорты. Универсальные.",
    price: 2_990, discount: 0, stock_quantity: 50,
    sku: "DP-SHT-001", category: categories[:шорты], brand: brands[:denimpro],
    gender: "all", sizes: %w[S M L XL], material: "100% хлопок", color: "Голубой",
    care_instructions: "Стирать при 30°C",
    img: "https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=600&h=600&fit=crop"
  },
  {
    name: "Шорты спортивные",
    description: "Лёгкие шорты для бега и фитнеса. Быстросохнущие.",
    price: 1_990, discount: 0, stock_quantity: 90,
    sku: "SM-SHT-001", category: categories[:шорты], brand: brands[:sportmaster],
    gender: "male", sizes: %w[S M L XL], material: "100% полиэстер", color: "Чёрный",
    care_instructions: "Стирать при 30°C",
    img: "https://images.unsplash.com/photo-1572490122747-0b6f8c66c8d2?w=600&h=600&fit=crop"
  },
  {
    name: "Бермуды",
    description: "Удлинённые шорты до колена. Несколько карманов.",
    price: 3_290, discount: 0, stock_quantity: 40,
    sku: "SC-SHT-001", category: categories[:шорты], brand: brands[:streetcode],
    gender: "male", sizes: %w[S M L XL], material: "100% хлопок", color: "Хаки",
    care_instructions: "Стирать при 40°C",
    img: "https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=600&h=600&fit=crop"
  },

  # === Пальто ===
  {
    name: "Пальто дабл",
    description: "Двубортное пальто с поясом. Шерстяная ткань.",
    price: 22_990, discount: 0, stock_quantity: 9,
    sku: "EL-CT-001", category: categories[:пальто], brand: brands[:elegance],
    gender: "female", sizes: %w[XS S M L], material: "100% шерсть", color: "Пудровый",
    care_instructions: "Только химчистка",
    img: "https://images.unsplash.com/photo-1551232864-3f0890e580d9?w=600&h=600&fit=crop"
  },
  {
    name: "Парка зимняя",
    description: "Тёплая парка с меховой отделкой капюшона. До -25°C.",
    price: 16_990, discount: 25, stock_quantity: 4,
    sku: "NW-PRK-001", category: categories[:пальто], brand: brands[:nordicwool],
    gender: "all", sizes: %w[S M L XL], material: "100% полиэстер, мех искусственный", color: "Зелёный",
    care_instructions: "Стирать при 30°C, сушить в расправленном виде",
    img: "https://images.unsplash.com/photo-1602329661395-61a30a6dd546?w=600&h=600&fit=crop"
  },

  # === Аксессуары ===
  {
    name: "Шапка бини",
    description: "Вязаная шапка крупной вязки. Базовый аксессуар.",
    price: 990, discount: 0, stock_quantity: 150,
    sku: "NW-ACC-001", category: categories[:аксессуары], brand: brands[:nordicwool],
    gender: "all", sizes: %w[S M L], material: "100% шерсть", color: "Чёрный",
    care_instructions: "Ручная стирка",
    img: "https://images.unsplash.com/photo-1576871337622-98d48d1cf531?w=600&h=600&fit=crop"
  },
  {
    name: "Шарф кашемировый",
    description: "Мягкий шарф из кашемира. Добавляет уюта.",
    price: 3_490, discount: 0, stock_quantity: 0,
    sku: "EL-ACC-001", category: categories[:аксессуары], brand: brands[:elegance],
    gender: "all", sizes: %w[S M L], material: "100% кашемир", color: "Бежевый",
    care_instructions: "Только химчистка",
    img: "https://images.unsplash.com/photo-1605458559597-4fb127e09d16?w=600&h=600&fit=crop"
  },
  {
    name: "Рюкзак городской",
    description: "Компактный рюкзак с отделением для ноутбука.",
    price: 4_990, discount: 0, stock_quantity: 30,
    sku: "UE-ACC-001", category: categories[:аксессуары], brand: brands[:urbanedge],
    gender: "all", sizes: %w[S M L], material: "100% нейлон", color: "Чёрный",
    care_instructions: "Протирать влажной губкой",
    img: "https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?w=600&h=600&fit=crop"
  },
].freeze

ITEMS.each do |attrs|
  Product.create!(
    name: attrs[:name],
    description: attrs[:description],
    price: attrs[:price],
    discount: attrs[:discount],
    stock_quantity: attrs[:stock_quantity],
    sku: attrs[:sku],
    category_id: attrs[:category].id,
    brand_id: attrs[:brand].id,
    gender: attrs[:gender],
    sizes: attrs[:sizes],
    material: attrs[:material],
    color: attrs[:color],
    care_instructions: attrs[:care_instructions],
    status: :published,
    in_stock: attrs[:stock_quantity] > 0
  )
end

Product.find_each do |p|
  attrs = ITEMS.find { |i| i[:sku] == p.sku }
  next unless attrs && attrs[:img]
  begin
    p.images.attach(
      io: URI.open(attrs[:img], open_timeout: 15, read_timeout: 15),
      filename: "#{p.sku}.jpg"
    )
  rescue OpenURI::HTTPError, SocketError, Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout => e
    Rails.logger.warn "Failed to load image for #{p.name}: #{e.message}"
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
