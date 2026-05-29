class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :product_id, message: "Вы уже оставили отзыв на этот товар" }

  after_commit :update_product_average_rating, on: [ :create, :destroy ]

  private

  def update_product_average_rating
    product.update_average_rating
  end
end
