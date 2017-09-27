Rails.application.routes.draw do
  root to: 'staticpages#home'

  namespace :admin do
    resources :bookprices, :deliveries, :orders,
              :socialicons, :users, :partners
    resources :phgalleries do
      resources :images, only: %i[create destroy]
    end
  end
  resources :bookpages, :bookprices, :deliveries,
            :discounts, :socialicons, :pages,
            :partners
  resources :books do
    resources :bookpages
    resources :phgalleries do
      resources :images, only: %i[create destroy]
    end
  end
  resources :orders do
    get :bookprint
  end
  resources :phgalleries do
    resources :images, only: %i[create destroy]
  end
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users

  get 'admin', to: 'admin/users#index', as: :admin_page
  get 'home', to: 'staticpages#home', as: :home_page
  get 'about_us', to: 'staticpages#about_us', as: :about_us_page
  get 'how_to_order', to: 'staticpages#how_to_order', as: :how_to_order_page
  get 'faq', to: 'staticpages#faq', as: :faq_page
  get 'delivery', to: 'staticpages#delivery', as: :delivery_page
  get 'advantages', to: 'staticpages#advantages', as: :advantages_page
  get 'trust_us', to: 'staticpages#trust_us', as: :trust_us_page
  get 'events', to: 'staticpages#events', as: :events_page
  get 'inprocess', to: 'statispages#inprocess', as: :in_process
end
