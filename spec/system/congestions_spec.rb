require 'rails_helper'

RSpec.describe "Congestion管理", type: :system do
  let(:user) { create(:user) }
  let(:shop) { create(:shop) }

  context "未ログインユーザー" do
    it "投稿ボタンを押すとログインを促される" do
      visit shop_path(shop)
      expect(page).to have_link "混雑情報を投稿"

      click_link "混雑情報を投稿"
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content "ログインもしくはアカウント登録してください"
    end
  end

  context "ログイン済みユーザー" do
    before do
      login(user)
      expect(page).to have_content "ログインしました"
      visit new_shop_congestion_path(shop)
      expect(page).to have_content "混雑情報を投稿"
    end

    it "混雑情報を投稿できる" do
      # テストの安定性を保つため、日曜日を固定日付に設定
      visited_on = Date.new(2025, 9, 7)
      fill_in "訪問日", with: visited_on
      select "0:00〜2:00", from: "訪問時間帯"
      select "満席近い", from: "混雑度"
      click_button "投稿する"

      expect(page).to have_content I18n.t('flash.congestion.create')
      expect(page).to have_content shop.name

      click_button "混雑情報"
      expect(page).to have_content "日"
      click_button "日"
      expect(page).to have_content "1件"
    end

    it "必須項目が空だとエラーが表示される" do
      fill_in "訪問日", with: ""
      click_button "投稿する"

      expect(page).to have_content "訪問日を入力してください"
    end
  end
end
