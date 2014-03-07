Railstom::Application.routes.draw do

  get '/', :to => 'home#locale_root'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # angular's templates
  get '/templates/*id' => 'templates#show', :as => :template, :format => false

  devise_for :users, only: :omniauth_callbacks, controllers: {
    omniauth_callbacks: 'omniauth_callbacks'
  }

  scope '/:locale', constraints: { locale: /[a-z]{2}((-|_)[a-zA-Z]{2})?/ } do
    root :to => 'home#index'

    devise_for :users, skip: :omniauth_callbacks, controllers: {
      registrations: 'registrations'
    }

    devise_scope :user do
      get '/users/reset_password', to: 'registrations#reset_password', as: :reset_password_user_registration
      post 'auth/:provider/new', to: 'omniauth_callbacks#new', as: :auth_at_provider
    end

    get '/locale_pages/*id' => 'pages#locale_show', :as => :locale_page, :format => false
    get '/pages/*id' => 'pages#show', :as => :page, :format => false

    resource :cancel_accounts, only: [:edit, :destroy]
    resource :user_settings, only: [:edit, :update] do
      member do
        get :authentication
      end
    end
  end

  require 'constraints/admin'
  constraints Constraint::Admin do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end
