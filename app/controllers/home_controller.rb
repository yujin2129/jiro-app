class HomeController < ApplicationController
  def index
    @shops = Shop
      .left_joins(:favorites)
      .group("shops.id")
      .order("COUNT(favorites.id) DESC")
      .limit(6)
  end
end
