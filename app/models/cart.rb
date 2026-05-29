class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy

  validates :session_token, presence: true, unless: -> { user_id.present? }

  def total_amount
    cart_items.sum { |item| item.product.final_price * item.quantity }
  end

  def items_count
    cart_items.sum(:quantity)
  end
end
