require 'rails_helper'

RSpec.describe "Shop管理", type: :system do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, admin: true) }
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
    before { login(user) }

    it "管理者ページにアクセスできない" do
      expect(page).to have_content "ログインしました"

      visit new_shop_path
      expect(current_path).to eq root_path
      expect(page).to have_content "管理者のみが操作できます"
    end

    it "編集・削除リンクが見えない" do
      expect(page).to have_content "ログインしました"

      visit shop_path(shop)
      expect(page).not_to have_link "編集"
      expect(page).not_to have_button "削除"
    end
  end

  context "管理者" do
    before { login(admin) }

    it "新規作成・編集・削除できる" do
      expect(page).to have_content "ログインしました"

      visit new_shop_path
      expect(page).to have_content "新規店舗登録"

      visit edit_shop_path(shop)
      expect(page).to have_content "店舗情報編集"

      visit shops_path
      expect(page).to have_button "削除"
    end
  end
end
