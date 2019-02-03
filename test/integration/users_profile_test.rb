require 'test_helper'
#Userpロフィール画面に対するテスト
class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    #GETリクエスト user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    # assert_select htmlタグ 'h1>img.gravatar' を探す。
    # h1タグ (トップレベルの見出し) の内側にある、gravatarクラス付きのimgタグがあるかどうかをチェック
    assert_match @user.microposts.count.to_s, response.body
    # assert_match 正規表現に文字列がマッチすれば成功
    # assert_selectよりもずっと抽象的なメソッドです。
    # assert_selectではどのHTMLタグを探すのか伝える必要があるが、assert_matchメソッドではその必要がない
    #response.bodyにはそのページの完全なHTMLが含まれている
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_select 'div.pagination', count: 1
    # assert_select 'HTML' count: 1 
    # will_paginateに該当する、div class=paginationが1度のみ表示されていることをテスト
  end
end
