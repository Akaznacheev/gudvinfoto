Rails.application.routes.draw do
  root 'static_pages#home'

  namespace :admin do
    # constraints subdomain: 'admin' do
    resources :price_lists, :deliveries, :orders, :social_icons, :users, :partners
    resources(:galleries) { resources :images, only: %i[create destroy] }
    # end
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :book_pages, :changes, :pages, :partners, :users
  resources :books do
    resources :book_pages
    resources(:galleries) { resources :images, only: %i[create destroy] }
  end
  resources(:orders) { get :book_print }

  get 'admin', to: 'admin/users#index', as: :admin_page
  get 'home', to: 'static_pages#home', as: :home_page
  get 'about_us', to: 'static_pages#about_us', as: :about_us_page
  get 'how_to_order', to: 'static_pages#how_to_order', as: :how_to_order_page
  get 'faq', to: 'static_pages#faq', as: :faq_page
  get 'delivery', to: 'static_pages#delivery', as: :delivery_page
  get 'advantages', to: 'static_pages#advantages', as: :advantages_page
  get 'trust_us', to: 'static_pages#trust_us', as: :trust_us_page
  get 'events', to: 'static_pages#events', as: :events_page
  get 'in_process', to: 'static_pages#in_process', as: :in_process
  get 'choose_book_format', to: 'static_pages#choose_book_format', as: :choose_book_format
  get 'holst_about', to: 'static_pages#holst_about', as: :holst_about
  get 'changelog', to: 'changes#index', as: :changelog
  # StaticPagesController.action_methods.each do |action|
  #  get "/#{action}", to: "pages##{action}", as: "#{action}_page"
  # end
end
