Rails.application.routes.draw do
  devise_for :users

  root to: "homes#top"
  get '/home/about' => "homes#about", as: "about"
  get 'relationships/followings'
  get 'relationships/followers'
  get 'search' => 'searches#search'

  resources :books, only:[:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only:[:index,:show,:edit,:update] do
  #日付別投稿数表示
    get 'search' => 'users#search'
    resource :relationships, only:[:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

