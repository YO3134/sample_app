class StaticPagesController < ApplicationController
# ApplicationControllerクラスを継承

  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    #@micropost = current_user.microposts.build if logged_in?
    # 後置if ログインしているかどうか
    end
  end

  def help
  end

  def about
  end

  def contact
  end

#   def helf
#   end
end
