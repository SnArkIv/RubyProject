class Address < ApplicationRecord
  belongs_to :user

  validates :full_name, :phone, :city, :street, :house, presence: true
  validates :full_name, format: { with: /\A[а-яА-ЯёЁa-zA-Z\s\-]+\z/, message: "может содержать только буквы, пробелы и тире" }
  validates :phone, format: { with: /\A\+?\d[\d\s\-\(\)]+\d\z/, message: "должен содержать только цифры" }
  validates :zip_code, format: { with: /\A\d{6}\z/, message: "должен состоять из 6 цифр" }, allow_blank: true
  validates :city, :street, format: { with: /\A[а-яА-ЯёЁa-zA-Z\s\-\.]+\z/, message: "может содержать только буквы, пробелы и тире" }
  validates :house, format: { with: /\A[\d\w\-\/]+\z/, message: "должен содержать номер дома" }

  after_save :ensure_single_default, if: :saved_change_to_is_default?

  private

  def ensure_single_default
    return unless is_default?

    user.addresses.where.not(id: id).update_all(is_default: false)
  end
end
