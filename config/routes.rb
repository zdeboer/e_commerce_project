Rails.application.routes.draw do
  get "stripe_checkout/create"
  get "stripe_checkout/success"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :customers

  root "home#index"

  resources :products, only: [ :index, :show ]
  resources :genres, only: [ :show ]
  resource :cart, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ]
  resource :checkout, only: [ :show, :create ]
  resources :orders, only: [ :index, :show ]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post "/checkout/create", to: "stripe_checkout#create"
  get "/checkout/success", to: "stripe_checkout#success"
end
