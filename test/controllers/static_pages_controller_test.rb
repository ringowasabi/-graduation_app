require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "top page is displayed" do
    get root_path

    assert_response :success
    assert_select "h1", text: /いつもの訪問先の交通費/
    assert_select "a[href=?]", signup_path, text: "新規登録"
    assert_select "a[href=?]", login_path, text: "ログイン"
  end
end
