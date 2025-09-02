require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "名前、メール、パスワードがあれば有効" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "名前が必須" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it "名前が20文字以内であること" do
      user = build(:user, name: "a" * 21)
      expect(user).not_to be_valid
    end
  end

  describe "#admin?" do
    it "admin が true の場合は true を返す" do
      user = build(:user, admin: true)
      expect(user.admin?).to eq true
    end

    it "admin が false の場合は false を返す" do
      user = build(:user, admin: false)
      expect(user.admin?).to eq false
    end
  end

  describe "アソシエーション" do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorite_shops).through(:favorites).source(:shop) }
    it { should have_many(:congestions).dependent(:nullify) }
  end
end
