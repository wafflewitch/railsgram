Rails.application.routes.draw do
  devise_for :users
  resources :posts
  resources :users, only: [:show], param: :username, path: ''
  root to: 'welcome#index'
end
