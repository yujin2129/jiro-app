class Congestion < ApplicationRecord
  VISITED_TIME_SLOTS = [
    "0:00〜2:00", "2:00〜4:00", "4:00〜6:00",
    "6:00〜8:00", "8:00〜10:00", "10:00〜12:00",
    "12:00〜14:00", "14:00〜16:00", "16:00〜18:00",
    "18:00〜20:00", "20:00〜22:00", "22:00〜24:00"
  ]

  belongs_to :shop
  belongs_to :user

  validates :visited_on, :visited_time, :level, presence: true
  validates :visited_time, inclusion: { in: VISITED_TIME_SLOTS }
  validates :level, inclusion: { in: 1..5 }

end
