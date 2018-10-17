Rails.application.routes.draw do
  get 'static_pages/home'
  #　/static_pages/homeというURLに対するリクエストをStaticPagesコントローラのhomeアクションに結ぶ
  #　GETリクエスト

  get 'static_pages/help'
  get 'static_pages/about'
  # /static_pages/aboutというURLに対してGETリクエストが来たら、StaticPagesコントローラのaboutアクションに渡す

  root 'application#hello'
end
