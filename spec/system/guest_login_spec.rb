require 'rails_helper'

RSpec.describe "ゲストログイン", type: :system do
  it "一般ゲストユーザーでログインできる" do
    visit new_user_session_path
    click_button "ゲストログイン（一般）"

    expect(page).to have_content I18n.t('flash.user.guest_login')
    expect(page).to have_current_path(root_path)
  end

  it "管理者ゲストユーザーでログインできる" do
    visit new_user_session_path
    click_button "ゲストログイン（管理者）"

    expect(page).to have_content I18n.t('flash.user.guest_admin_login')
    expect(page).to have_current_path(root_path)
  end
end
