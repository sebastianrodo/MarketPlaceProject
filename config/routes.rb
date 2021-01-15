Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :products
  resources :categories

  root to: "products#index"
  put "/products/:id/archive" => "products#archive"
  put "/products/:id/publish" => "products#publish"
  get "/my_products", to: "products#my_products", as: :my_products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
