Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations',
        omniauth_callbacks: 'users/omniauth_callbacks',
        passwords: 'users/passwords'
      }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  resources :users, only: [] do
    member do
      get :following
      get :followers
      post :follow, to: 'relationships#follow'
      post :unfollow, to: 'relationships#unfollow'
    end
  end

  root to: 'top#index'
  get 'top', to: 'top#index'

  resources :posts do
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
    resource :favorites, only: [:create, :destroy]
      collection do
        get :bookmarks
        get :autocomplete
      end
  end

  resources :tags, only: [:show] do
    resources :posts, only: [:index]
  end

  resource :profile, only: [:show, :edit, :update]
  resources :accounts, only: [:show] do
    resources :follows, only: [:create]
    resources :unfollows, only: [:create]
  end
  resources :bookmarks, only: %i[create destroy]

  get 'images/ogp.png', to: 'images#ogp', as: 'images_ogp'

   get 'diagnoses', to: 'diagnoses#index'
   resources :coffee_beans, only: [:new] do
    collection do
      get :result
    end
  end

  resources :desserts, only: [:new] do
    collection do
      get :result
    end
  end

  resources :drinks, only: [:new] do
    collection do
      get :result
    end
  end
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'contact', to: redirect('https://forms.gle/z8sibaa5aQfKe9os8')
  # Defines the root path route ("/")
  # root "postsindex"
  resources :daily_advices, only: [:index, :create, :destroy]
end
