Rails.application.routes.draw do

  root to: 'pages#home'

  get 'admin', to: 'admin/users#index', as: :admin_page
  namespace :admin do
    resources :bookprices, :deliveries, :orders, :socialicons, :users
    resources :phgalleries do
      resources :images, :only => [:create, :destroy]
    end
  end

  resources :bookpages, :bookprices, :deliveries, :discounts, :socialicons
  resources :books do
    resources :bookpages
    resources :phgalleries do
      resources :images, :only => [:create, :destroy]
    end
  end
  resources :orders do
    get :bookprint
  end
  resources :phgalleries do
    resources :images, :only => [:create, :destroy]
  end

  get 'home', to: 'pages#home', as: :home_page
  get 'about_us', to: 'pages#about_us', as: :about_us_page
  get 'how_to_order', to: 'pages#how_to_order', as: :how_to_order_page
  get 'faq', to: 'pages#faq', as: :faq_page
  get 'delivery', to: 'pages#delivery', as: :delivery_page
  get 'advantages', to: 'pages#advantages', as: :advantages_page
  get 'trust_us', to: 'pages#trust_us', as: :trust_us_page

  devise_for :users
  resources :users
end