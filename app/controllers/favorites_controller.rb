class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop

  def create
    @shop.favorites.create(user: current_user)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to shop_path(@shop), notice: "お気に入り追加" }
    end
  end

  def destroy
    favorite = @shop.favorites.find_by(user: current_user)
    favorite.destroy if favorite
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to shop_path(@shop), notice: "お気に入り解除" }
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
