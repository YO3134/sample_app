require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    #特定のリンクが存在するかどうかを、aタグとhref属性をオプションで指定
    assert_select "a[href=?]",root_path,count:2
    #Homeページのリンクの個数も調べることもできる
    assert_select "a[href=?]",help_path
    assert_select "a[href=?]",about_path
    #Railsは自動的にはてなマーク "?" をabout_pathに置換
    assert_select "a[href=?]",contact_path

    get contact_path
    assert_select "title", full_title("Contact")

    get signup_path
    assert_equal "Sign up | Ruby on Rails Tutorial Sample App", full_title("Sign up")
  end
end
