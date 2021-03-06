News3::Application.routes.draw do
  ActiveAdmin.routes(self)
  mount RedactorRails::Engine => '/redactor_rails'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations',
    sessions: 'sessions',
    confirmations: 'confirmations',
    passwords: 'passwords'
  }

  root 'articles#index'
  get 'categories/:category_id' => 'articles#list', as: 'category'
  resources :articles do
    collection do
      get 'search'
      post 'preview'
      post 'get_more'
      get 'subscribe/:category_id', to: 'articles#subscribe', as: 'subscribe'
      get 'unsubscribe/:category_id', to: 'articles#unsubscribe', as: 'unsubscribe'
    end
    resources :comments, only: [:create, :destroy]
  end
end
