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
end
