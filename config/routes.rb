Railstom::Application.routes.draw do
  root :to => 'home#locale_root'

  scope '/:locale', constraints: { locale: /[a-z]{2}/ } do
    root :to => 'home#index'

    devise_for :users, controllers: {
      omniauth_callbacks:  'omniauth_callbacks'
    }

    get '/pages/*id' => 'pages#locale_show', :as => :locale_page, :format => false
  end
end
