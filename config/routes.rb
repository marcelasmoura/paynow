Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :home, only: :index 
    resources :payment_methods
    resources :client_users, only: [:index, :show, :edit, :update]
    post 'token/new_token'
  end

  namespace :client do
    resources :home, only: :index
    resources :business_registers, only: [:new, :create, :edit, :update, :show]
    resources :access, only: [:index] 
    resources :token, only: :index
    resources :payment_method_options
    post 'access/allow'
    post 'access/deny'
    post 'token/new_token'
  end
  
  root 'home#index'
end
