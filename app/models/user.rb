class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  enum :role, { customer: 0, manager: 1, admin: 2 }, prefix: true

  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  has_many :addresses, dependent: :destroy

  before_validation :normalize_email

  validates :email, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/ }
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, confirmation: true, if: -> { password.present? }

  def admin?
    role_admin?
  end

  def manager?
    role_manager?
  end

  def customer?
    role_customer?
  end

  def admin_or_manager?
    admin? || manager?
  end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end
