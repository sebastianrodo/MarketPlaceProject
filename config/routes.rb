Rails.application.routes.draw do
  root to: "products#index"
  devise_for :users

  resources :users
  resources :products
  resources :categories

  put "/products/:id/archive" => "products#archive"
end
