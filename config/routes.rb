Rails.application.routes.draw do
  get 'static_pages/home'
  #　/static_pages/homeというURLに対するリクエストをStaticPagesコントローラのhomeアクションに結ぶ
  #　GETリクエスト

  get 'static_pages/help'
  #
  #

  root 'application#hello'
end
