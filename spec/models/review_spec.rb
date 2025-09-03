require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "バリデーション" do
    it "rating と content, user, shop があれば有効" do
      review = build(:review)
      expect(review).to be_valid
    end

    it "rating が必須" do
      review = build(:review, rating: nil)
      expect(review).not_to be_valid
    end

    it "rating が 1〜5 の範囲であること" do
      review = build(:review, rating: 6)
      expect(review).not_to be_valid
    end

    it "content が必須" do
      review = build(:review, content: nil)
      expect(review).not_to be_valid
    end

    it "content が長すぎると無効" do
      review = build(:review, content: "a" * 501)
      expect(review).not_to be_valid
    end

    it "user が必須" do
      review = build(:review, user: nil)
      expect(review).not_to be_valid
    end

    it "shop が必須" do
      review = build(:review, shop: nil)
      expect(review).not_to be_valid
    end
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should belong_to(:shop) }
    it { should have_many_attached(:images) }
  end
end
