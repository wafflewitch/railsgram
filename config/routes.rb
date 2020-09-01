Rails.application.routes.draw do
  devise_for :users

  resources :followers, only: [:create, :destroy], param: :user_id

  resources :posts do
    collection do
      get 'explore'
      get 'tagged'
    end
    resource :likes, only: [:create, :destroy], module: :posts
    resources :comments, only: [:create, :new, :show, :destroy], module: :posts
  end

  resources :users, only: [:show], param: :username, path: '' do
    resources :posts, only: [:show], module: :users
  end

  # get 'posts/tagged', to: "posts#tagged", as: :tagged

  root to: 'welcome#index'
end
