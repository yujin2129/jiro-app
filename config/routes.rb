Rails.application.routes.draw do
  devise_for :users
  resources :shops do
    resources :reviews, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end
  get "users/profile", to: "users#show", as: "user_profile"
end
