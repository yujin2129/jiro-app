Rails.application.routes.draw do
  devise_for :users
  resources :shops
  get "users/profile", to: "users#show", as: "user_profile"
end
