Rails.application.routes.draw do
  get 'home/index'
  root "home#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    post 'users/guest_admin_sign_in', to: 'users/sessions#guest_admin_sign_in'
  end

  resources :shops do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
    resource :favorite, only: [:create, :destroy]
    resources :congestions, only: [:new, :create]
  end
  get "users/profile", to: "users#show", as: "user_profile"
end
