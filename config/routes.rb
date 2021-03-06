Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Tell it which controller and action will handle the home page: controller home, action show
  root to: 'home#show'
  resources :posts, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :featured_posts, only: [:index]
  get '/about', to: 'pages#about', as: :about

  namespace :admin do
    get '/', to: 'posts#index', as: 'root'
    resources :categories
    # nested routing
    resources :posts do
      resources :post_images, only: [:new, :create, :destroy]
    end
  end
end
