require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)

    #このコードは慣習的に正しくない
    #@micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    #Micropost.new引数(content: "Lorem ipsum", user_id: @user.id)を実行し、
    #インスタンス変数micropostに代入
    #↓書き換え(慣習的に正しくマイクロポストを作成する)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
    #インスタンス変数 @micropost.valid? オブジェクトにエラーがない場合はtrueが返る
  end

  test "user id should be present" do
    @micropost.user_id = nil
    #@micropost.user_id = nil
    assert_not @micropost.valid?
    # assert_not testはfalse インスタンス変数 @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first"do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
