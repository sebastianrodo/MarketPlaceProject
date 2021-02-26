Rails.application.routes.draw do
  resources :users, only: [:index, :new, :create, :show]
  resources :products, only: [:index, :new, :create, :destroy]
end
