class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop

  def create
    @review = @shop.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to shop_path(@shop), notice: "レビューを投稿しました"
    else
      set_shop_resources
      render "shops/show", status: :unprocessable_entity
    end
  end

  def destroy
    @review = @shop.reviews.find(params[:id])
    if @review.user == current_user
      @review.destroy
      redirect_to shop_path(@shop), notice: "レビューを削除しました"
    else
      redirect_to shop_path(@shop), alert: "削除できません"
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def review_params
    params.require(:review).permit(:content, :rating, images: [])
  end
end
