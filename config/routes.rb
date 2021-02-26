Rails.application.routes.draw do
  resources :categories
  devise_for :users
  root to: "products#index"
  resources :users, only: [:index, :new, :create, :show, :destroy]
  resources :products, only: [:index, :new, :create, :destroy]
end
