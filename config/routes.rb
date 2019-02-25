Rails.application.routes.draw do
  root 'static_pages#home'
  #get 'static_pages/home'
  #/static_pages/homeというURLに対するリクエストをStaticPagesコントローラのhomeアクションに結ぶ
  #GETリクエスト
  #get 'static_pages/help'

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get '/help', to:'static_pages#help'
  #get 'static_pages/about'
  get '/about', to:'static_pages#about'
  # /static_pages/aboutというURLに対してGETリクエストが来たら、StaticPagesコントローラのaboutアクションに渡す
  #get 'static_pages/contact'
  get '/contact', to:'static_pages#contact'
  #ルーティングの変更で名前付きルート (*_path) が使える
  #get '/helf', to:'static_pages#helf'
  get '/signup', to:'users#new'
  post '/signup', to:'users#create'
  #「名前付きルーティング」だけを使う｀
  # GET POSTリクエストを loginルーティング
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # DELETEリクエストを logoutルーティングで扱う

  # Usersコントローラにfollowingアクションとfollowersアクションを追加する
  # URL /users/1/following /users/1/followers
  resources :users do
    member do
      get :following, :followers
    end
  end

  # resources RESTfulなURLを自動生成(resources)
  # index show new create edit update destroy
  resources :users
  resources :account_activations,     only:[:edit]
  resources :password_resets,         only:[:new, :create, :edit, :update]
  # resourcesを用いる
  resources :microposts,              only: [:create, :destroy]
  # POST   /microposts   create   microposts_path
  # DELETE /microposts/1 destroy  microposts_path(micropost)

  #Relationshipsリソース用のルーティングを追加する
  resources :relationships,           only: [:create, :destroy]
end

