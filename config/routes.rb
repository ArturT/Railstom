Railstom::Application.routes.draw do

  root :to => 'home#locale_root'

  # angular's templates
  get '/templates/*id' => 'templates#show', :as => :template, :format => false

  scope '/:locale', constraints: { locale: /[a-z]{2}/ } do
    root :to => 'home#index'

    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    devise_for :users, controllers: {
      omniauth_callbacks: 'omniauth_callbacks',
      registrations: 'registrations'
    }

    devise_scope :user do
      get '/users/reset_password' => 'registrations#reset_password', :as => 'reset_password_user_registration'
    end

    get '/locale_pages/*id' => 'pages#locale_show', :as => :locale_page, :format => false
    get '/pages/*id' => 'pages#show', :as => :page, :format => false

    resource :cancel_accounts, only: [:edit, :destroy]
  end
end
