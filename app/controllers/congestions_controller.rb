class CongestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop

  def create
    @congestion = @shop.congestions.new(congestion_params)
    @congestion.user = current_user
    if @congestion.save
      redirect_to shop_path(@shop), notice: "混雑情報を投稿しました"
    else
      set_shop_resources
      render "shops/show", status: :unprocessable_entity
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
