Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show], param: :username, path: ''
  root to: 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
