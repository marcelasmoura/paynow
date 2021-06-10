Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :home, only: :index 
    resources :payment_methods
  end

  namespace :client do
    resources :home, only: :index
    resources :business_registers, only: [:new, :create, :edit, :update, :show]
  end
  
  root 'home#index'
end
