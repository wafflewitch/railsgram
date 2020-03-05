Rails.application.routes.draw do
  devise_for :users
  resources :posts
  resources :users, only: [:show], param: :username, path: '' do
    resources :posts, only: [:show], module: :users
  end
  root to: 'welcome#index'
end
