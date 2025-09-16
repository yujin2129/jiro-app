require 'rails_helper'

RSpec.describe "Shop管理", type: :system do
  describe "ログイン制御" do
    let(:user) { create(:user) }
    let(:admin) { create(:user, admin: true) }
    let!(:shop) { create(:shop) }

    context "未ログインユーザー" do
      it "一覧と詳細は見れる" do
        visit shops_path
        expect(page).to have_content shop.name

        visit shop_path(shop)
        expect(page).to have_content shop.name
        expect(page).to have_link "ログインしてお気に入り登録"
      end

      it "管理者ページにアクセスできない" do
        visit new_shop_path
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content "ログインもしくはアカウント登録してください"
      end
    end

    context "一般ユーザー" do
      before do
        login(user)
        expect(page).to have_content "ログインしました"
      end

      it "管理者ページにアクセスできない" do
        visit new_shop_path
        expect(current_path).to eq root_path
        expect(page).to have_content I18n.t('flash.errors.admin_only')
      end

      it "編集・削除リンクが見えない" do
        visit shop_path(shop)
        expect(page).not_to have_link "編集"
        expect(page).not_to have_button "削除"
      end
    end

    context "管理者" do
      before do
        login(admin)
        expect(page).to have_content "ログインしました"
      end

      it "新規作成・編集・削除できる" do
        visit new_shop_path
        expect(page).to have_content "新規店舗登録"

        visit edit_shop_path(shop)
        expect(page).to have_content "店舗情報編集"

        visit shops_path
        expect(page).to have_button "削除"
      end

      it "新規作成が失敗する（名前が空の場合）" do
        visit new_shop_path
        fill_in "店舗名", with: ""
        fill_in "住所", with: "東京都千代田区テスト町1-1-1"
        click_button "登録する"

        expect(page).to have_content "店舗名を入力してください"
      end
    end
  end

  describe "並び替え" do
    let(:shop1) { create(:shop, name: "A店") }
    let(:shop2) { create(:shop, name: "B店") }
    let!(:review1) { create(:review, rating: 3, shop: shop1) }
    let!(:review2) { create(:review, rating: 5, shop: shop2) }

    before do
      visit shops_path
    end

    it "評価順で並び替えできる" do
      select "評価順", from: "並び替え"

      shop_names = all(".card-body .card-title").map(&:text)
      expect(shop_names.index(shop2.name)).to be < shop_names.index(shop1.name)
    end
  end
end
