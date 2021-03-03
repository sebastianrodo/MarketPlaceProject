# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "products#index"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, :categories
  resources :products do
    member do
      put :archive
      put :publish
    end

    collection do
      get :my_products
    end
  end
end
