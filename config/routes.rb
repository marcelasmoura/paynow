Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :home, only: :index 
    resources :payment_methods, only: [:index, :new, :create]
  end
  
  root 'home#index'
end
