require 'rails_helper'

RSpec.describe "ユーザーの認証機能", type: :system do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }

  describe "ユーザー登録" do
    it "成功する場合" do
      visit new_user_registration_path

      fill_in "名前", with: "テスト太郎"
      fill_in "メール", with: "newuser@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認用）", with: "password"
      click_button "登録する"

      expect(page).to have_content "アカウント登録が完了しました"
      expect(page).to have_content "テスト太郎"
    end

    it "失敗する場合（必須項目が空）" do
      visit new_user_registration_path

      fill_in "名前", with: ""
      fill_in "メール", with: ""
      fill_in "パスワード", with: ""
      click_button "登録する"

      expect(page).to have_content "名前を入力してください"
      expect(page).to have_content "Eメールを入力してください"
      expect(page).to have_content "パスワードを入力してください"
    end
  end

  describe "ログイン" do
    it "成功する場合" do
      login(user)

      expect(page).to have_content "ログインしました"
      expect(page).to have_content user.name
    end

    it "失敗する場合（間違ったパスワード）" do
      visit new_user_session_path

      fill_in "メール", with: "test@example.com"
      fill_in "パスワード", with: "wrongpass"
      click_button "ログイン"

      expect(page).to have_content "Eメールまたはパスワードが違います"
      expect(page).not_to have_content user.name
    end
  end

  describe "ログアウト" do
    it "成功する" do
      login(user)
      visit root_path

      click_on user.name
      click_button "ログアウト"

      expect(page).to have_content "ログアウトしました"
      expect(page).not_to have_content user.name
    end
  end
end
