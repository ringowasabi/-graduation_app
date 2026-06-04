require "test_helper"

class TransportationMemosControllerTest < ActionDispatch::IntegrationTest
  test "logged in user can access index" do
    post login_path, params: {
      email: users(:kaori).email,
      password: "password123"
    }

    get transportation_memos_path

    assert_response :success
    assert_select "h1", "交通費メモ一覧"
    assert_select "a[href=?]", logout_path, text: "ログアウト"
  end

  test "redirects guest to login page" do
    get transportation_memos_path

    assert_redirected_to login_path
    assert_equal "ログインしてください。", flash[:alert]
  end

  test "logged out user cannot access index" do
    post login_path, params: {
      email: users(:kaori).email,
      password: "password123"
    }
    delete logout_path

    get transportation_memos_path

    assert_redirected_to login_path
  end
end
