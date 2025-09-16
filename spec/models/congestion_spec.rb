require 'rails_helper'

RSpec.describe Congestion, type: :model do
  describe "バリデーション" do
    it "shop, user, visited_on, visited_time, level があれば有効" do
      congestion = build(:congestion)
      expect(congestion).to be_valid
    end

    it "visited_on が必須" do
      congestion = build(:congestion, visited_on: nil)
      expect(congestion).not_to be_valid
    end

    it "visited_time が必須" do
      congestion = build(:congestion, visited_time: nil)
      expect(congestion).not_to be_valid
    end

    it "level が必須" do
      congestion = build(:congestion, level: nil)
      expect(congestion).not_to be_valid
    end

    it "level は 1〜5 の範囲であること" do
      congestion = build(:congestion, level: 6)
      expect(congestion).not_to be_valid
    end

    it "user が必須" do
      congestion = build(:congestion, user: nil)
      expect(congestion).not_to be_valid
    end

    it "shop が必須" do
      congestion = build(:congestion, shop: nil)
      expect(congestion).not_to be_valid
    end
  end

  describe "定数 VISITED_TIME_SLOTS" do
    it "定数に含まれない visited_time は無効" do
      congestion = build(:congestion, visited_time: "25:00〜27:00")
      expect(congestion).not_to be_valid
    end
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:shop) }
  end
end
