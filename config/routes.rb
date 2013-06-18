Railstom::Application.routes.draw do
  root :to => 'home#locale_root'

  scope '/:locale', constraints: { locale: /[a-z]{2}/ } do
    root :to => 'home#index'

    devise_for :users
  end
end
