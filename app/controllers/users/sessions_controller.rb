class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: t('flash.user.guest_login')
  end

  def guest_admin_sign_in
    user = User.guest_admin
    sign_in user
    redirect_to root_path, notice: t('flash.user.guest_admin_login')
  end
end
