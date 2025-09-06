require 'rails_helper'

RSpec.describe "Review管理", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:shop) { create(:shop) }
  let!(:review) { create(:review, user: user, shop: shop) }

  context "未ログインユーザー" do
    it "投稿ボタンを押すとログインを促される" do
      visit shop_path(shop)
      expect(page).to have_link "レビューを投稿"

      click_link "レビューを投稿"
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content "ログインもしくはアカウント登録してください"
    end
  end

  context "ログイン済みユーザー（本人）" do
    before do
      login(user)
      expect(page).to have_content "ログインしました"
    end

    it "レビューを新規投稿できる" do
      visit new_shop_review_path(shop)
      expect(page).to have_content "レビューを投稿"

      find("label[for=rating_5]").click
      fill_in "レビュー内容", with: "最高の一杯！"
      click_button "投稿する"

      expect(page).to have_content "レビューを投稿しました"
      expect(page).to have_content shop.name

      click_button "レビュー"
      expect(page).to have_content "最高の一杯！"
    end

    it "レビュー投稿が失敗する（内容が空の場合）" do
      visit new_shop_review_path(shop)
      expect(page).to have_content "レビューを投稿"
    
      find("label[for=rating_5]").click
      fill_in "レビュー内容", with: ""
      click_button "投稿する"
    
      expect(page).to have_content "レビュー内容を入力してください"
    end

    it "レビューを編集できる" do
      visit edit_shop_review_path(shop, review)
      expect(page).to have_content "レビューを編集"

      fill_in "レビュー内容", with: "味が濃かった"
      click_button "更新する"

      expect(page).to have_content "レビューを更新しました"
      expect(page).to have_content shop.name

      click_button "レビュー"
      expect(page).to have_content "味が濃かった"
    end

    it "レビューを削除できる" do
      visit shop_path(shop)
      expect(page).to have_content shop.name

      click_button "レビュー"
      expect(page).to have_content review.content

      accept_confirm do
        click_on "削除"
      end
      expect(page).to have_content "レビューを削除しました"
      expect(page).not_to have_content review.content
    end
  end

  context "ログイン済みユーザー（他人のレビュー）" do
    before do
      login(other_user)
      expect(page).to have_content "ログインしました"
    end

    it "編集・削除リンクが表示されない" do
      visit shop_path(shop)
      expect(page).to have_content shop.name
      click_button "レビュー"

      expect(page).not_to have_link "編集"
      expect(page).not_to have_button "削除"
    end
  end
end
