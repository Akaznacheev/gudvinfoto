Rails.application.routes.draw do

  root to: 'pages#home'
  get 'dashboard', to: 'pages#dashboard'

  devise_for :users
  resources :users

  resources :books do
    resources :bookpages
    resources :phgalleries
    resources :phgalleries do
      resources :images, :only => [:create, :destroy]
    end
  end
  resources :bookpages
  resources :phgalleries do
    resources :images, :only => [:create, :destroy]
  end
end