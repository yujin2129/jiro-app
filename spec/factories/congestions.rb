FactoryBot.define do
  factory :congestion do
    association :user
    association :shop
    visited_on { Faker::Date.between(from: 1.month.ago, to: Date.today) }
    visited_time { Congestion::VISITED_TIME_SLOTS.sample }
    level { rand(1..5) }
  end
end
