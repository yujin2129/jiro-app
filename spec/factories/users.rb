FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "TestPassword123!" }
    password_confirmation { "TestPassword123!" }
  end
end
