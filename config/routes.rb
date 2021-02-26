Rails.application.routes.draw do
  resources :categories
  devise_for :users
  root to: "products#index"
  resources :users
  resources :products
end
