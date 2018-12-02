Rails.application.routes.draw do
root 'static_pages#home'
  #get 'static_pages/home'
  #/static_pages/homeというURLに対するリクエストをStaticPagesコントローラのhomeアクションに結ぶ
  #GETリクエスト
  #get 'static_pages/help'
  get '/help', to:'static_pages#help'
  #get 'static_pages/about'
  get '/about', to:'static_pages#about'
  # /static_pages/aboutというURLに対してGETリクエストが来たら、StaticPagesコントローラのaboutアクションに渡す
  #get 'static_pages/contact'
  get '/contact', to:'static_pages#contact'
  #ルーティングの変更で名前付きルート (*_path) が使える
  #get '/helf', to:'static_pages#helf' 
  get '/signup', to:'users#new'
end
