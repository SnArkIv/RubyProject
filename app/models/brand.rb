class Brand < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
