require 'rails_helper'

RSpec.describe "ホーム画面", type: :system do
  let!(:shop1) { create(:shop, name: "ラーメン二郎本店") }
  let!(:shop2) { create(:shop, name: "ラーメン山田") }

  describe "人気店舗" do
    before do
      create_list(:favorite, 2, shop: shop1)
      create(:favorite, shop: shop2)
      visit root_path
    end

    it "人気店舗が表示される" do
      expect(page).to have_content "人気店舗"
      expect(page).to have_content shop1.name
      expect(page).to have_content shop2.name
    end

    it "人気順に並んでいる" do
      shop_names = all(".card-body .card-title").map(&:text)
      expect(shop_names.index(shop1.name)).to be < shop_names.index(shop2.name)
    end
  end

  describe "検索" do
    before do
      visit root_path
    end

    it "検索でヒットする場合" do
      fill_in "店舗名や住所で検索", with: "二郎"
      click_button "検索"

      expect(page).to have_content "ラーメン二郎本店"
      expect(page).not_to have_content "ラーメン山田"
    end

    it "検索でヒットしない場合" do
      fill_in "店舗名や住所で検索", with: "天下一品"
      click_button "検索"

      expect(page).to have_content "該当する店舗が見つかりませんでした"
      expect(page).not_to have_content "ラーメン二郎本店"
      expect(page).not_to have_content "ラーメン山田"
    end

    it "空検索の場合は全件表示" do
      fill_in "店舗名や住所で検索", with: ""
      click_button "検索"

      expect(page).to have_content "ラーメン二郎本店"
      expect(page).to have_content "ラーメン山田"
    end
  end
end
