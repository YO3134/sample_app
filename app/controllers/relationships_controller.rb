class RelationshipsController < ApplicationController
  before_action :logged_in_user
  # 定義されているアクションが実行される前に :logged_in_userが動作する

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    respond_to do | format|
      format.html { redirect_to @user}
      format.js
    end
  end
end

# Ajaxに対応させるためにユーザーのローカル変数(user)をインスタンス変数(@user)に変更
