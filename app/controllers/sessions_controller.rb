class SessionsController < ApplicationController

  def new
  end

  def create
    # user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])
    #   log_in user
    #   remember user
    #   params[:session][:remember_me] == '1'?remember(user):forget(user)
    #   redirect_to user #user_url(user)
    #   #ユーザーログイン後にユーザー情報のページにリダイレクトする

    #list9.27
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1'?remember(@user):forget(@user)
      redirect_to @user
    else
      # flash[:danger] = 'Invalid email/password combination' #error
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # logged_in?がtrueの場合に限ってlog_outを呼び出す。
    log_out if logged_in?
    redirect_to root_url
  end
end