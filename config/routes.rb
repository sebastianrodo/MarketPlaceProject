Rails.application.routes.draw do
  root to: "products#index"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :users
  resources :products
  resources :categories

  put "/products/:id/archive", to: "products#archive", :as => :archive
  put "/products/:id/publish", to: "products#publish", :as => :publish
  get "/my_products", to: "products#my_products", as: :my_products
end
