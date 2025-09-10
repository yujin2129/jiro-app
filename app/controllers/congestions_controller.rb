class CongestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop

  def new
    @congestion = @shop.congestions.new
  end

  def create
    @congestion = @shop.congestions.new(congestion_params)
    @congestion.user = current_user
    if @congestion.save
      redirect_to shop_path(@shop), notice: I18n.t('flash.congestion.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def congestion_params
    params.require(:congestion).permit(:visited_on, :visited_time, :level)
  end
end
