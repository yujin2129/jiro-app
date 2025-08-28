class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_shop_resources
    @reviews = @shop.reviews.includes(:user)
    @congestions = @shop.congestions
    @congestions_by_day = @congestions.group_by { |c| c.visited_on&.wday }
  end
end
