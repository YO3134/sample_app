require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # テストコード起動のためにメソッドNEWに引数として必要な値を与え、インスタンス変数userに代入
    @user = User.new(name: "Example User", email: "user@example.com",
    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    #  ユーザーの有効性についてテスト
    assert @user.valid?
    #@user.valid？が真であるかについて検証
    #valid?によってバリデーションを任意のタイミングでトリガ
  end

  test "name should be present" do
    #nameの有無についてテスト
    @user.name = "  "
    #＠user.nameに””を代入
    assert_not @user.valid?
    #@user.valid?が偽であるか検証
  end

  test "email should be present" do
    #Eメールの有無についてテスト
    @user.email = "  "
    #@user.emailに””を代入
    assert_not @user.valid?
    #@user.valid?が偽であるか検証
  end

  test "name should not be too long" do
    #nameの長さについてテスト
    @user.name = "a" * 51
    #"a*51"を@user.nameに代入
    assert_not @user.valid?
    #@user.valid?が偽であるか検証
  end

  test "email should not be too long" do
    #eメールの長さについテストを行う
    @user.email = "a" * 244 + "@example.com"
    #@user.emailに"a" * 244 + "@example.com"を代入
    assert_not @user.valid?
    #@user.valid?が偽であるか検証
    #
  end

  test "email validation should accept valid addresses" do
    #有効的なEメールについてテスト
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    #%w[]配列を作り、valid_addressesに代入
    valid_addresses.each do |valid_address|
    #変数valid_addressesに含まれる値を順に取り出す
      @user.email = valid_address
      #取り出した値を@user.emailに代入
      assert @user.valid?, "#{valid_address.inspect} should be valid"
      #@user.valid? が真であるか検証 valid_address.inspect(文字列として出力する)
    end
  end

  test "email validation should reject invalid addresses" do
    #無効なメールを拒否するテスト
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    #%w[]配列を作り、invalid_addressesに代入
    invalid_addresses.each do |invalid_address|
    #invalid_addressから値を順に取り出す
      @user.email = invalid_address
      #@user.emailに値を代入
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
      #@user.valid?が偽であるか検証する invalid_address(文字列として出力する)
    end
  end

  test "password should be present (nonblank)" do
  #passwordの有無についてテスト
    @user.password = @user.password_confirmation = "" * 6
    #インスタンス変数@user.passwordに
    #password_confirmationを使うとpassword_digestというカラムに暗号化したデータを格納する
    assert_not @user.valid?
    #@user.valid?が偽であるか検証する
  end

  test "password should have a minimum length" do
    #パスワードの最小の長さについてテスト
    @user.password = @user.password_confirmation = "a" * 5
    #@user.passwordに@user.passwrd_confirmationを使い"a" * 5を格納する
    assert_not @user.valid?
    #@user.valid?が偽であるか検証する
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")

    #assert_difference yieldされたブロックで評価された結果である式の戻り値における数値の違いをテストする。
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    #ローカル変数michaelにメソッドuser引数（：michael）を代入
    archer = users(:archer)
    #ローカル変数archerにメソッドuser引数（：archer）を代入
    assert_not michael.following?(archer)
    #michaelをarcherがフォローしていなければTrue
    michael.follow(archer)
    #archerがmichaelをフォローする
    assert michael.following?(archer)
    #archerがmichaelをフォローしていることを確認
    assert archer.followers.include?(michael)
    # michaelのフォロワーにarcherが含まれているか？
    michael.unfollow(archer)
    #archerからmichaelへのフォローを解除
    assert_not michael.following?(archer)
    #archerがmichaelをフォローしていないことを確認する
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    #フォローしているユーザーの投稿を確認 
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    #自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
