Rails.application.routes.draw do
  devise_for :users
  root to: "products#index"
  resources :users, only: [:index, :new, :create, :show, :destroy]
  resources :products, only: [:index, :new, :create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
