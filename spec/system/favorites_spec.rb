require 'rails_helper'

RSpec.describe "Favorite管理", type: :system do
  let(:user) { create(:user) }
  let(:shop) { create(:shop) }

  context "未ログインユーザー" do
    it "お気に入り登録リンクを押すとログインを促される" do
      visit shop_path(shop)
      expect(page).to have_link "ログインしてお気に入り登録"

      click_link "ログインしてお気に入り登録"
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "ログイン済みユーザー" do
    before do
      login(user)
      expect(page).to have_content "ログインしました"
      visit shop_path(shop)
    end

    it "店舗をお気に入り登録できる" do
      expect(page).to have_button "お気に入り登録"

      click_button "お気に入り登録"
      expect(page).to have_button "お気に入り解除"
    end

    it "店舗のお気に入りを解除できる" do
      click_button "お気に入り登録"
      expect(page).to have_button "お気に入り解除"

      click_button "お気に入り解除"
      expect(page).to have_button "お気に入り登録"
    end
  end
end
