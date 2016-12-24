Rails.application.routes.draw do

  resources :discounts
  resources :deliveries
  resources :orders do
    get :bookprint
  end
  resources :bookprices
  resources :socialicons
  root to: 'pages#home'

  devise_for :users
  resources :users

  get 'home', to: 'pages#home', as: :home_page
  get 'faq', to: 'pages#faq', as: :faq_page
  get 'shipping_and_payment', to: 'pages#shipping_and_payment', as: :shipping_and_payment_page
  get 'about', to: 'pages#about', as: :about_page
  get 'dashboard', to: 'pages#dashboard', as: :dashboard_page

  resources :books do
    resources :bookpages
    resources :phgalleries do
      resources :images, :only => [:create, :destroy]
    end
  end
  resources :bookpages
  resources :phgalleries do
    resources :images, :only => [:create, :destroy]
  end
end