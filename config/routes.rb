Rails.application.routes.draw do
  resources :users, only: [:index, :new, :create]
  resources :products, only: [:index, :new, :create]
end
