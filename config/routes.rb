News3::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations',
    sessions: 'sessions',
    confirmations: 'confirmations',
    passwords: 'passwords'
  }
  root 'articles#index'

  get 'categories/:category_id' => 'articles#index', as: 'category'
  resources :articles do
    get 'search', on: :collection
    post 'preview', on: :collection
    resources :comments, only: [:create, :destroy]
  end
end
