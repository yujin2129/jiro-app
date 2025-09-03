require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe "バリデーション" do
    it "名前と住所があれば有効" do
      shop = build(:shop)
      expect(shop).to be_valid
    end

    it "名前は必須" do
      shop = build(:shop, name: nil)
      expect(shop).not_to be_valid
    end

    it "名前が50文字以内であること" do
      shop = build(:shop, name: "あ" * 51)
      expect(shop).not_to be_valid
    end

    it "住所は必須" do
      shop = build(:shop, address: nil)
      expect(shop).not_to be_valid
    end

    it "住所が100文字以内であること" do
      shop = build(:shop, address: "あ" * 101)
      expect(shop).not_to be_valid
    end

    it "メニューは1000文字以内" do
      shop = build(:shop, menu: "a" * 1001)
      expect(shop).not_to be_valid
    end

    it "ルールは300文字以内" do
      shop = build(:shop, rules: "a" * 301)
      expect(shop).not_to be_valid
    end
  end

  describe "アソシエーション" do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorited_by_users).through(:favorites) }
    it { should have_many(:congestions).dependent(:destroy) }
    it { should have_many_attached(:images) }
  end

  describe "#average_rating と #average_rating_stars" do
    let(:shop) { create(:shop) }

    context "レビューがない場合" do
      it "average_rating は 0 を返す" do
        expect(shop.average_rating).to eq 0
      end

      it "average_rating_stars は 0 を返す" do
        expect(shop.average_rating_stars).to eq 0
      end
    end

    context "レビューがある場合" do
      before do
        create(:review, shop: shop, rating: 3)
        create(:review, shop: shop, rating: 4)
      end

      it "average_rating は平均値を返す" do
        expect(shop.average_rating).to eq 3.5
      end

      it "average_rating_stars は四捨五入して返す" do
        expect(shop.average_rating_stars).to eq 4
      end
    end
  end

  describe "スコープ" do
    let!(:shop1) { create(:shop, created_at: 1.day.ago) }
    let!(:shop2) { create(:shop, created_at: 2.days.ago) }
    let!(:shop3) { create(:shop, created_at: Time.current) }

    describe ".order_by_newest" do
      it "新しい順に並ぶこと" do
        expect(Shop.order_by_newest).to eq [shop3, shop1, shop2]
      end
    end

    describe ".order_by_rating" do
      before do
        create(:review, shop: shop1, rating: 3)
        create(:review, shop: shop2, rating: 5)
        create(:review, shop: shop3, rating: 1)
      end

      it "平均評価の高い順に並ぶこと" do
        expect(Shop.order_by_rating).to eq [shop2, shop1, shop3]
      end
    end

    describe ".order_by_favorites" do
      before do
        create(:favorite, user: create(:user), shop: shop1)
        2.times { create(:favorite, user: create(:user), shop: shop2) }
      end

      it "お気に入り数の多い順に並ぶこと" do
        expect(Shop.order_by_favorites).to eq [shop2, shop1, shop3]
      end
    end
  end
end
