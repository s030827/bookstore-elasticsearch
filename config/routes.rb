Rails.application.routes.draw do
  root to: 'home#index'

  resources :books do
    resources :reviews, only: [:create, :destroy]
  end
  resources :orders
  resources :order_items, only: [:create, :destroy]

  resources :checkout_w

  get 'catalog', to: 'books#index'
  get 'cart', to: 'cart#show'
  get 'checkout', to: 'checkout#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
