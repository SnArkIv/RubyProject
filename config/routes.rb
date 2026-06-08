Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root "pages#about"

  get "catalog", to: "catalog#index", as: :catalog
  resources :products, only: [ :show ]

  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register",
    password: "password"
  }, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }

  resource :profile, only: [ :show, :edit, :update ]
  resource :cart, only: [ :show ] do
    post "add_item", to: "carts#add_item", as: :add_item
    patch "update_item/:id", to: "carts#update_item", as: :update_item
    delete "remove_item/:id", to: "carts#remove_item", as: :remove_item
  end
  resources :orders, only: [ :index, :show, :new, :create ] do
    member do
      post :repeat
    end
  end
  resources :reviews, only: [ :create, :destroy ]
  resources :favorites, only: [ :index, :create, :destroy ]
  resources :addresses, except: [ :show ]

  namespace :api do
    namespace :v1 do
      get "catalog", to: "catalog#index"
      resources :products, only: [ :show ]
      resources :categories, only: [ :index ]
      resources :brands, only: [ :index ]

      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      get "auth/me", to: "auth#me"

      resource :profile, only: [ :show, :update ]
      resource :cart, only: [ :show ] do
        post "items", to: "carts#add_item"
        patch "items/:id", to: "carts#update_item"
        delete "items/:id", to: "carts#remove_item"
      end
      resources :orders, only: [ :index, :show, :create ] do
        member do
          post :repeat
        end
      end
      resources :favorites, only: [ :index, :create, :destroy ]
      resources :addresses, except: [ :show, :new, :edit ]
      resources :reviews, only: [ :create, :destroy ]
      get "products/:product_id/reviews", to: "reviews#index"
    end
  end

  namespace :admin do
    root "dashboard#index"
    resources :products
    resources :categories
    resources :brands
    resources :orders, only: [ :index, :show, :update ]
    resources :users, only: [ :index, :show, :edit, :update ]
  end
end
