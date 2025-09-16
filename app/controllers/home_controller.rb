class HomeController < ApplicationController
  def index
    @shops = Shop.order_by_favorites.limit(6)
  end
end
