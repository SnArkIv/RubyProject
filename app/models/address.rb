class Address < ApplicationRecord
  belongs_to :user

  validates :full_name, :phone, :city, :street, :house, presence: true

  after_save :ensure_single_default, if: :saved_change_to_is_default?

  private

  def ensure_single_default
    return unless is_default?

    user.addresses.where.not(id: id).update_all(is_default: false)
  end
end
