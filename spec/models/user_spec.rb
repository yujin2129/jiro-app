require "rails_helper"

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

  describe ".guest" do
    it "ゲストユーザーを作成または取得できること" do
      user = User.guest
      expect(user).to be_a(User)
      expect(user.email).to eq("guest@example.com")
      expect(user.name).to eq("ゲストユーザー")
      expect(user.admin).to be_falsey
    end

    it "既に存在する場合は新規作成せずに返すこと" do
      existing_user = User.guest
      expect { User.guest }.not_to change(User, :count)
      expect(User.guest.id).to eq(existing_user.id)
    end
  end

  describe ".guest_admin" do
    it "ゲスト管理者を作成または取得できること" do
      admin_user = User.guest_admin
      expect(admin_user).to be_a(User)
      expect(admin_user.email).to eq("guest_admin@example.com")
      expect(admin_user.name).to eq("ゲスト管理者")
      expect(admin_user.admin).to be_truthy
    end
  end

  describe "アソシエーション" do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorite_shops).through(:favorites).source(:shop) }
    it { should have_many(:congestions).dependent(:nullify) }
  end

  describe "dependent オプション" do
    it "ユーザーを削除すると関連するレビューも削除される" do
      user = create(:user)
      create(:review, user: user)

      expect { user.destroy }.to change { Review.count }.by(-1)
    end

    it "ユーザーを削除しても関連する混雑情報は削除されず nullify される" do
      user = create(:user)
      congestion = create(:congestion, user: user)

      user.destroy
      expect(congestion.reload.user).to be_nil
    end
  end
end
