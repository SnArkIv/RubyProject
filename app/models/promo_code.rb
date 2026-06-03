class PromoCode < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :discount, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  scope :active, -> { where(active: true).where("expires_at IS NULL OR expires_at > ?", Time.current) }

  def valid_for_use?
    active && (expires_at.nil? || expires_at > Time.current) && (max_uses.nil? || uses_count < max_uses)
  end

  def use!
    PromoCode.update_counters(id, uses_count: 1)
  end
end