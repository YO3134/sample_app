class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user #user_url(user)
      #ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
      # flash[:danger] = 'Invalid email/password combination' #error
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
