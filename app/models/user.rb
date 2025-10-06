class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_shops, through: :favorites, source: :shop
  has_many :congestions, dependent: :nullify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  def admin?
    admin
  end

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.name = "ゲストユーザー"
      user.password = "password"
    end
  end

  def self.guest_admin
    find_or_create_by!(email: "guest_admin@example.com") do |user|
      user.name = "ゲスト管理者"
      user.password = "password"
      user.admin = true
    end
  end
end
