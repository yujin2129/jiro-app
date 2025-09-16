class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @reviews = @user.reviews.includes(:shop).order(created_at: :desc)
    @favorite_shops = @user.favorite_shops.order(:name)
  end
end
