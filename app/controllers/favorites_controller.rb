class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop

  def create
    @shop.favorites.create(user: current_user)
    redirect_to shop_path(@shop), notice: "お気に入りに追加しました"
  end

  def destroy
    favorite = @shop.favorites.find_by(user: current_user)
    favorite.destroy if favorite
    redirect_to shop_path(@shop), notice: "お気に入りを解除しました"
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
