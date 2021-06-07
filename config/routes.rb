Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :home, only: :index 
  end
  
  root 'home#index'
end
