class Shop < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :congestions, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true, length: { maximum: 50 }
  validates :address, presence: true, length: { maximum: 100 }
  validates :menu, length: { maximum: 1000 }
  validates :rules, length: { maximum: 300 }

  def average_rating
    avg = reviews.average(:rating)
    avg ? avg.round(1) : 0
  end

  def average_rating_stars
    average_rating.round
  end

  scope :order_by_rating, -> {
    left_joins(:reviews)
      .group(:id)
      .order(Arel.sql("COALESCE(AVG(reviews.rating), 0) DESC"))
  }

  scope :order_by_favorites, -> {
    left_joins(:favorites)
      .group(:id)
      .order(Arel.sql("COUNT(favorites.id) DESC"))
  }

  scope :order_by_newest, -> { order(created_at: :desc) }
end
