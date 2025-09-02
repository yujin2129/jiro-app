FactoryBot.define do
  factory :review do
    association :user
    association :shop
    rating { rand(1..5) }
    content { "テストレビューです" }
  end
end
