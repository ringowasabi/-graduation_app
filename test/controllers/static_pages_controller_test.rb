require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "top page is displayed" do
    get root_path

    assert_response :success
    assert_select "h1", text: /いつもの訪問先の交通費/
    assert_select "a[href=?]", signup_path, text: "新規登録"
    assert_select "a[href=?]", login_path, text: "ログイン"
  end

  test "top page displays logged in navigation" do
    post login_path, params: {
      email: users(:kaori).email,
      password: "password123"
    }

    get root_path

    assert_response :success
    assert_select "a[href=?]", transportation_memos_path, text: "交通費メモ一覧"
    assert_select "a[href=?]", new_transportation_memo_path, text: "交通費メモを登録する"
    assert_select "a[href=?]", transportation_memos_path, text: "交通費メモ一覧を見る"
    assert_select "a[href=?]", signup_path, text: "交通費メモをはじめる", count: 0
    assert_select "a[href=?]", login_path, text: "ログインする", count: 0
    assert_select "form[action=?][method=?]", logout_path, "post"
    assert_select "input[name=?][value=?]", "_method", "delete"
  end
end
