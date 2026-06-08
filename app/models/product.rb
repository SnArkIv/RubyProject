class Product < ApplicationRecord
  has_many_attached :images

  belongs_to :category
  belongs_to :brand
  has_many :order_items, dependent: :nullify
  has_many :cart_items, dependent: :nullify
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum :status, { draft: 0, published: 1, archived: 2 }, prefix: true

  GENDERS = {
    "all" => "Все",
    "male" => "М",
    "female" => "Ж"
  }.freeze

  validates :name, :price, :category, :brand, presence: true
  validates :sku, uniqueness: true, allow_blank: true
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  before_save :auto_generate_sku

  scope :published, -> { where(status: :published) }
  scope :in_stock, -> { where(in_stock: true) }
  scope :on_sale, -> { where("discount > 0") }
  scope :search, ->(query) {
    return all if query.blank?
    q = "%#{query.downcase}%"
    where("LOWER(name) ILIKE ? OR LOWER(sku) ILIKE ?", q, q)
  }
  scope :by_category, ->(id) { id.present? ? where(category_id: id) : all }
  scope :by_brand, ->(ids) { ids.present? ? where(brand_id: ids) : all }
  scope :by_gender, ->(g) {
    if g.present? && g != "all"
      where("products.gender = ? OR products.gender = ?", g, "all")
    else
      all
    end
  }
  scope :by_sizes, ->(sizes) { sizes.present? ? where("sizes && ARRAY[?]::varchar[]", sizes) : all }
  scope :by_colors, ->(colors) { colors.present? ? where(color: colors) : all }
  scope :price_min, ->(min) { min.present? ? where("price >= ?", min) : all }
  scope :price_max, ->(max) { max.present? ? where("price <= ?", max) : all }
  scope :price_asc, -> { order(price: :asc) }
  scope :price_desc, -> { order(price: :desc) }
  scope :newest, -> { order(created_at: :desc) }
  scope :in_stock_first, -> { order(Arel.sql("in_stock DESC, created_at DESC")) }
  scope :discount_desc, -> { order(discount: :desc) }
  scope :by_popularity, -> {
    select("products.*, COALESCE((
      SELECT SUM(order_items.quantity) FROM order_items WHERE order_items.product_id = products.id
    ), 0) as popularity_score")
      .order(Arel.sql("popularity_score DESC"))
  }
  scope :similar, ->(product) {
    where(category_id: product.category_id)
      .where.not(id: product.id)
      .published
      .in_stock
      .order(created_at: :desc)
      .limit(4)
  }

  def final_price
    price * (1 - discount / 100.0)
  end

  def on_sale?
    discount > 0
  end

  def discount_percent
    on_sale? ? discount : 0
  end

  def display_price
    format("%.0f", price)
  end

  def display_final_price
    format("%.0f", final_price)
  end

  def update_average_rating
    avg = reviews.average(:rating) || 0.0
    update_column(:average_rating, avg.round(2))
  end

  def in_stock
    return self[:in_stock] if stock_by_size.blank? || stock_by_size.empty?
    stock_by_size.values.sum(&:to_i) > 0
  end

  def stock_quantity
    return self[:stock_quantity] if stock_by_size.blank? || stock_by_size.empty?
    stock_by_size.values.sum(&:to_i)
  end

  def low_stock?
    in_stock? && stock_quantity > 0 && stock_quantity < 50
  end

  def gender_label
    GENDERS[gender] || gender
  end

  def stock_for_size(size)
    return stock_quantity if stock_by_size.blank? || stock_by_size.empty?
    stock_by_size[size.to_s].to_i
  end

  def in_stock_for_size?(size)
    in_stock? && stock_for_size(size) > 0
  end

  private

  def auto_generate_sku
    return if sku.present?
    prefix = category&.name&.first(3)&.upcase || "PRD"
    count = Product.where(category_id: category_id).count + 1
    self.sku = "#{prefix}-#{count.to_s.rjust(4, '0')}"
  end
end
