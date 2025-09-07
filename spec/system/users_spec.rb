require 'rails_helper'

RSpec.describe "ユーザーの認証機能", type: :system do
  let!(:user) { create(:user) }

  describe "ユーザー登録" do
    it "成功する場合" do
      visit new_user_registration_path

      fill_in "名前", with: "テスト太郎"
      fill_in "Eメール", with: "newuser@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認用）", with: "password"
      click_button "登録する"

      expect(page).to have_content "アカウント登録が完了しました"
      expect(page).to have_content "テスト太郎"
    end

    it "失敗する場合（必須項目が空）" do
      visit new_user_registration_path

      fill_in "名前", with: ""
      fill_in "Eメール", with: ""
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

      fill_in "Eメール", with: "test@example.com"
      fill_in "パスワード", with: "wrongpass"
      click_button "ログイン"

      expect(page).to have_content "Eメールまたはパスワードが違います"
      expect(page).not_to have_content user.name
    end
  end

  describe "ログアウト" do
    before do
      login(user)
      expect(page).to have_content "ログインしました"
    end

    it "成功する" do
      visit root_path
      click_on user.name
      click_button "ログアウト"
      
      expect(page).to have_content "ログアウトしました"
      expect(page).not_to have_content user.name
    end
  end

  describe "マイページ（プロフィール）機能" do
    let!(:review) { create(:review, user: user) }
    let(:favorite_shop) { create(:shop) }
    let!(:favorite) { create(:favorite, user: user, shop: favorite_shop) }
  
    before do
      login(user)
      expect(page).to have_content "ログインしました"
      visit user_profile_path(user)
    end
  
    it "プロフィール情報が表示される" do
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_link "プロフィールを編集"
    end
  
    it "投稿したレビューが表示される" do
      click_button "投稿レビュー"
      expect(page).to have_content "投稿したレビュー"
      expect(page).to have_content review.content
    end
  
    it "お気に入り店舗が表示される" do
      click_button "お気に入り店舗"
      expect(page).to have_content "お気に入り店舗"
      expect(page).to have_content favorite_shop.name
    end
  end

  describe "マイページ（プロフィール編集）機能" do
    before do
      login(user)
      expect(page).to have_content "ログインしました"
      visit user_profile_path(user) # マイページ
      click_link "プロフィールを編集"
      expect(page).to have_content "プロフィール編集"
    end
  
    it "名前とメールアドレスを編集できる" do
      fill_in "名前", with: "新しい名前"
      fill_in "Eメール", with: "new_email@example.com"
      fill_in "現在のパスワード", with: user.password
      click_button "更新する"
  
      expect(page).to have_content "アカウント情報を変更しました"
      expect(current_path).to eq root_path
    end
  
    it "必須項目が空だとエラーが表示される" do
      fill_in "名前", with: ""
      fill_in "Eメール", with: ""
      fill_in "現在のパスワード", with: user.password
      click_button "更新する"
  
      expect(page).to have_content "名前を入力してください"
      expect(page).to have_content "Eメールを入力してください"
    end
  end
end
