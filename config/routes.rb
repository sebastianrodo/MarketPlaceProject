# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "products#index"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resource :users, only: [] do
    resources :products, only: :index, controller: 'users/products' do
      resource :archives, only: :update, controller: 'users/products/archives'
      resource :publishes, only: :update, controller: 'users/products/publishes'
    end
  end

  resources :users

  resources :products

  resources :categories
end
