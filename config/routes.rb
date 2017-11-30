Rails.application.routes.draw do
  root 'staticpages#home'

  namespace :admin do
    # constraints subdomain: 'admin' do
    resources :bookprices, :deliveries, :orders, :socialicons, :users, :partners
    resources(:phgalleries) { resources :images, only: %i[create destroy] }
    # end
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :bookpages, :pages, :partners, :users
  resources :books do
    resources :bookpages
    resources(:phgalleries) { resources :images, only: %i[create destroy] }
  end
  resources(:orders) { get :bookprint }
  resources(:phgalleries) { resources :images, only: %i[create destroy] }

  get 'admin', to: 'admin/users#index', as: :admin_page
  get 'home', to: 'staticpages#home', as: :home_page
  get 'about_us', to: 'staticpages#about_us', as: :about_us_page
  get 'how_to_order', to: 'staticpages#how_to_order', as: :how_to_order_page
  get 'faq', to: 'staticpages#faq', as: :faq_page
  get 'delivery', to: 'staticpages#delivery', as: :delivery_page
  get 'advantages', to: 'staticpages#advantages', as: :advantages_page
  get 'trust_us', to: 'staticpages#trust_us', as: :trust_us_page
  get 'events', to: 'staticpages#events', as: :events_page
  get 'inprocess', to: 'staticpages#inprocess', as: :in_process
  get 'book_about', to: 'staticpages#book_about', as: :book_about
  get 'holst_about', to: 'staticpages#holst_about', as: :holst_about
  # StaticpagesController.action_methods.each do |action|
  #  get "/#{action}", to: "pages##{action}", as: "#{action}_page"
  # end
end
