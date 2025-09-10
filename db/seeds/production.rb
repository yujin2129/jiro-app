require 'faker'

Review.destroy_all
Favorite.destroy_all
Congestion.destroy_all
User.destroy_all
Shop.destroy_all

shop_images = Dir.glob(Rails.root.join("app/assets/images/seeds/shop*.jpg"))
review_images = Dir.glob(Rails.root.join("app/assets/images/seeds/ramen*.jpg"))

shop_names = [
  "ラーメン二郎 立川店",
  "ラーメン二郎 亀戸店",
  "ラーメン二郎 府中店",
  "神保町二郎インスパイア",
  "二郎系豚増しラーメン",
  "野猿二郎風ラーメン",
  "ラーメンマシマシ本舗"
]

review_texts = [
  "野菜マシマシで最高でした！",
  "スープが濃厚で豚がうまい",
  "ニンニク多めでガッツリ系",
  "初めてでも食べやすくてボリューム満点",
  "麺が太くてモチモチ、また行きたい"
]

tokyo_addresses = [
  "東京都千代田区丸の内1-9-1",
  "東京都港区赤坂9-7-1",
  "東京都渋谷区渋谷2-21-1",
  "東京都新宿区西新宿2-8-1",
  "東京都台東区上野公園7-1",
  "東京都墨田区押上1-1-2",
  "東京都江東区青海1-1-10"
]

# 管理者ユーザー
User.create!(
  name: "Admin",
  email: "admin@example.com",
  password: "password",
  admin: true
)

# 一般ユーザー
users = 5.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password"
  )
end

# 店舗作成
shops = 10.times.map do |i|
  shop = Shop.create!(
    name: shop_names.sample,
    address: tokyo_addresses.sample,
    opening_hours: "11:00 - 22:00",
    holiday: ["月曜", "火曜", "水曜", "なし"].sample,
    menu: "ラーメン 800円、つけ麺 900円、チャーシュー 200円",
    rules: "食券制／並びあり／着席時に食券渡す/着丼前にコール"
  )
  rand(0..1).times do |j|
    shop.images.attach(io: File.open(shop_images.sample), filename: "shop#{i}_#{j}.jpg")
  end
  shop
end

# レビュー作成
5.times do |i|
  review = Review.create!(
    user: users.sample,
    shop: shops.sample,
    rating: rand(1..5),
    content: review_texts.sample
  )
  rand(0..1).times do |j|
    review.images.attach(io: File.open(review_images.sample), filename: "review#{i}_#{j}.jpg")
  end
end

# 混雑情報作成
20.times do
  Congestion.create!(
    user: users.sample,
    shop: shops.sample,
    visited_on: Faker::Date.between(from: 1.month.ago, to: Date.today),
    visited_time: Congestion::VISITED_TIME_SLOTS.sample,
    level: rand(1..5)
  )
end

# お気に入り作成
users.each do |user|
  shops.sample(rand(0..5)).each do |shop|
    Favorite.find_or_create_by!(user: user, shop: shop)
  end
end

puts "✅ seeds 完了: ユーザー#{User.count}, 店舗#{Shop.count}, レビュー#{Review.count}, 混雑#{Congestion.count}, お気に入り#{Favorite.count}"
