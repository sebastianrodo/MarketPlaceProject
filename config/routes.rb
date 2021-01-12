Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :products
  resources :categories

  root to: "products#index"
  put "/products/:id/archive" => "products#archive"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
