require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
# このテストはコードリーディングのよい練習台になりますので、みっちりお読みください。

  def setup
    ActionMailer::Base.deliveries.clear
    # ActionMailerから送信されたメールの配列を全て削除して、配列を空にする
    @user = users(:michael)
    # インスタンス変数userに変数users引数(：michael)を代入
  end

  test "password resets" do
    get new_password_reset_path
    # GETリクエスト new_password_reset_path
    assert_template 'password_resets/new'
    # assert_template そのアクションで指定されたテンプレートが描写されているかを検証
    # password_resetのnewアクションによるテンプレートが描写されているか

    #メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: ""} }
    #Postリクエスト password_resets_path
    assert_not flash.empty?
    #assert_not 偽ならTRUE 真ならFALSE  flashが空ならFALSE、でないならTRUE
    assert_template 'password_resets/new'
    # password_resetのnewアクションによるテンプレートが描写されているか

    #メールアドレスが有効
    post password_resets_path,
    #Postリクエスト password_resets_path
      params: { password_reset: { email: @user.email }}
      # パラメータ引数ハッシュ password_reset ハッシュ email: @user.email
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # @user.reset_digest != @user.reload.reset_digest である
    # assert_not_equal( expected, actual, [msg] )
    #expected != actualはtrueであると主張する。
    assert_equal 1, ActionMailer::Base.deliveries.size
    #assert_equal( expected, actual, [msg] )   expected == actualはtrueであると検証。
    # 1 == ActionMailer::Base.deliveries.sizeはTRUEであると検証
    assert_not flash.empty?
    #assert_not 偽ならTRUE 真ならFALSE  flashが空ならFALSE、でないならTRUE
    assert_redirected_to root_url
    #渡されたroot_urlが最後に実行されたアクションで呼び出されたリダイレクトオプションと一致することを検証
    #assert_redirected_to(options = {}, message=nil)
    #渡されたリダイレクトオプションが、最後に実行されたアクションで呼び出されたリダイレクトオプションと一致する

    #パスワード再設定フォームのテスト
    user = assigns(:user)
    #変数userに引数(:user)代入 assigns変数,直前に作られたインスタンス変数を取得
    #assigns(key = nil)  アクションを実行した結果、インスタンス変数に代入されたオブジェクトを取得

    #メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email:"")
    #GETリクエスト edit_password_reset_path 引数(user.reset_token, email:"")
    assert_redirected_to root_url
    #渡されたroot_urlが最後に実行されたアクションで呼び出されたリダイレクトオプションと一致することを検証


    #無効なユーザー
    user.toggle!(:activated)
    #有効なユーザーを反転し保存する=無効なユーザーを保存
    #toggle! その属性を反転し保存する saveに成功したらtrue 引数(:symbol)
    #toggle その属性を反転する-レコードを保存するにはsave(属性を反転したインスタンス)引数(:symbol)
    get edit_password_reset_path(user.reset_token, email: user.email)
    #GETリクエスト edit_password_reset_path Argument(user.reset_token, symbol user.email)
    #Getリクエストとは=>
    assert_redirected_to root_url
    #渡されたroot_urlが最後に実行されたアクションで呼び出されたリダイレクトオプションと一致することを検証
    user.toggle!(:activated)
    #有効なユーザーを反転し保存する=無効なユーザーを保存

    #メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email:user.email)
    assert_redirected_to root_url
    #渡されたroot_urlが最後に実行されたアクションで呼び出されたリダイレクトオプションと一致することを検証

    #メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    #GETリクエスト edit_password_reset_path Argument(user.reset_token, symbol user.email)
    #GETリクエストとは=>
    assert_template 'password_resets/edit'
    # password_resetsのeditアクションによるテンプレートが描写されているか
    assert_select "input[name=email][type=hidden][value=?]",user.email
    #inputタグに正しい名前、type="hidden",メールアドレスがあるかどうかを確認する。

    #無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
    #Pathchリクエスト password_reset_path argument(user.reset_token)
    #Patchリクエストとは
    params: { email: user.email,
    #パラメタ  ハッシュemail: ユーザのeメール
    # params URLから送られてきた値やフォームで入力した値をparams[:パラメータ名]で取得する
    user: { password: "foobaz",
    password_confirmation: "barquux" }}
    assert_select 'div#error_explanation'
    # アクション実行の結果として描写されるHTMLの内容を検証 'div#error_explanation'

    #パスワードが空
    patch password_reset_path(user.reset_token),
    params: { email: user.email,
    user: { password: "",
    password_confirmation: "" }}
    assert_select 'div#error_explanation'
    # アクション実行の結果として描写されるHTMLの内容を検証 'div#error_explanation'

    #有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
    params: { email: user.email,
    user: { password: "foobaz",
    password_confirmation: "foobaz" }}
    assert is_logged_in?
    #assert 式が真ならば成功
    assert_not flash.empty?
    #assert_not 偽ならTRUE 真ならFALSE  flashが空ならFALSE、でないならTRUE
    assert_redirected_to user
    #渡されたroot_urlが最後に実行されたアクションで呼び出されたリダイレクトオプションと一致することを検証
  end
end













