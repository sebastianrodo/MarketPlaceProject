Rails.application.routes.draw do
  devise_for :users
  root to: "products#index"
  resources :users, only: [:index, :new, :create, :show]
  resources :products, only: [:index, :new, :create, :destroy]
end
