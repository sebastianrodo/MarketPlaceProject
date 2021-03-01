Rails.application.routes.draw do
  root to: "products#index"
  devise_for :users

  resources :users
  resources :products
  resources :categories

  put "/products/:id/archive", to: "products#archive", :as => :archive
  put "/products/:id/publish", to: "products#publish", :as => :publish
  get "/my_products", to: "products#my_products", as: :my_products
end
