class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum :status, { pending: 0, confirmed: 1, shipped: 2, delivered: 3, cancelled: 4 }

  DELIVERY_METHODS = {
    "courier" => "Курьер",
    "post" => "Почта",
    "pickup" => "Самовывоз"
  }.freeze

  PAYMENT_METHODS = {
    "card_on_delivery" => "Картой при получении",
    "cash" => "Наличные"
  }.freeze

  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shipping_address, presence: true, if: :address_required?
  validates :delivery_method, inclusion: { in: DELIVERY_METHODS.keys }, allow_blank: true
  validates :payment_method, inclusion: { in: PAYMENT_METHODS.keys }, allow_blank: true

  def address_required?
    delivery_method != "pickup"
  end

  def delivery_method_label
    DELIVERY_METHODS[delivery_method] || delivery_method
  end

  def payment_method_label
    PAYMENT_METHODS[payment_method] || payment_method
  end
end
