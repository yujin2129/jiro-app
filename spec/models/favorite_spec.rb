require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe "バリデーション" do
    it "user, shop があれば有効" do
      favorite = build(:favorite)
      expect(favorite).to be_valid
    end

    it "user が必須" do
      review = build(:review, user: nil)
      expect(review).not_to be_valid
    end

    it "shop が必須" do
      review = build(:review, shop: nil)
      expect(review).not_to be_valid
    end

    it "同じユーザーが同じ店舗を2回お気に入りできない" do
      user = create(:user)
      shop = create(:shop)
      create(:favorite, user: user, shop: shop)
      duplicate = build(:favorite, user: user, shop: shop)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include("はすでに存在します")
    end
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:shop) }
  end
end
