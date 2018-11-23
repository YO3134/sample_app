Rails.application.routes.draw do
root 'static_pages#home'
  get 'static_pages/home'
  #/static_pages/homeというURLに対するリクエストをStaticPagesコントローラのhomeアクションに結ぶ
  #GETリクエスト

  get 'static_pages/help'
  get 'static_pages/about'
  # /static_pages/aboutというURLに対してGETリクエストが来たら、StaticPagesコントローラのaboutアクションに渡す
  get 'static_pages/contact'
end
