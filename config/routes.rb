Rails.application.routes.draw do
  get 'home/index'
  root "home#index"
  get "search", to: "shops#search", as: "shop_search"

  devise_for :users
  resources :shops do
    resources :reviews, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
    resources :congestions, only: [:create]
  end
  get "users/profile", to: "users#show", as: "user_profile"
end
