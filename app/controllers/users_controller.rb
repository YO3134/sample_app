class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index, :edit, :update, :destroy]
  # beforeフィルターは、before_actionメソッドを使って何らかの処理が実行される直前に特定のメソッドを実行する
  before_action :correct_user, only:[:edit, :update]
  #別のユーザーのプロフィールを編集しようとしたらリダイレクトさせる
  before_action :admin_user,   only: :destroy

  def index
    #User.allを使ってデータベース上の全ユーザーを取得し、ビューで使えるインスタンス変数@usersに代入
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    #インスタンス変数userにUserモデルからfindメソッドを用いて
    #引数(params[:id])による値を代入する
    @microposts = @user.microposts.paginate(page: params[:page])
    #@microposts変数をshowアクションに追加する
    #＠micropostsに@user.microposts.paginate引数(page: params[:id])
    #paginateメソッド マイクロポスト関連付けを
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      #ユーザーモデルオブジェクトからメールを送信する
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      #リダイレクト先をプロフィール先からルートURLに変更し、かつユーザーは以前のようにはログインしない

      # redirect_to user_url(@user)
      # Handle a succsessful save.
    else
      render 'new'
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    # update_attributesへの呼び出しでuser_paramsを使う点に注目
    # Strong Parametersを使ってマスアサインメントの脆弱性を防止
    if @user.update_attributes(user_params)
    #更新に成功した場合
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # before_action
    #ログイン済みユーザーかどうかを確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

