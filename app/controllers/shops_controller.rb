class ShopsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_shop, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:keyword].present?
      @shops = Shop.where("name LIKE ? OR address LIKE ?", "%#{params[:keyword]}%",
"%#{params[:keyword]}%")
    else
      @shops = Shop.all
    end

    case params[:sort]
    when "rating"
      @shops = @shops.order_by_rating
    when "favorites"
      @shops = @shops.order_by_favorites
    else
      @shops = @shops.order_by_newest
    end
  end

  def show
    @reviews = @shop.reviews.includes(:user)
    @congestions_by_day = @shop.congestions.group_by { |c| c.visited_on.wday }
  end

  def new
    @shop = Shop.new
  end

  def edit
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to shops_path, notice: I18n.t('flash.shop.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shop.update(shop_params)
      redirect_to @shop, notice: I18n.t('flash.shop.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shop.destroy
    redirect_to shops_path, notice: I18n.t('flash.shop.destroy')
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
      :menu,
      images: []
    )
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: I18n.t('flash.errors.admin_only')
    end
  end
end
