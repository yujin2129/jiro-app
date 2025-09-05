class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop
  before_action :set_review, only: [:edit, :update, :destroy]

  def new
    @review = @shop.reviews.new
  end

  def create
    @review = @shop.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to shop_path(@shop), notice: "レビューを投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to shop_path(@shop), notice: 'レビューを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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

  def set_review
    @review = @shop.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content, :rating, images: [])
  end
end
