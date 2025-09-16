FactoryBot.define do
  factory :shop do
    name { "ラーメン二郎テスト店" }
    address { "東京都新宿区西新宿1-1-1" }
    opening_hours { "11:00 - 22:00" }
    holiday { "月曜" }
    menu { "ラーメン 800円" }
    rules { "食券制" }
  end
end
