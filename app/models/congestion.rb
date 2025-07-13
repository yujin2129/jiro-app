class Congestion < ApplicationRecord
  belongs_to :shop
  belongs_to :user

  validates :visited_on, :visited_time, :level, presence: true
  validates :level, inclusion: { in: 1..5 }
end
