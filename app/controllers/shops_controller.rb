class ShopsController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update, :destroy]

  def index
    @shops = Shop.all
  end

  def show
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to shops_path, notice: '店舗を登録しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @shop.update(shop_params)
      redirect_to @shop, notice: '店舗情報を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to shops_path, notice: '店舗を削除しました。'
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(
      :name,
      :address,
      :rules,
      :opening_hours,
      :holiday,
      :image
    )
  end
end
