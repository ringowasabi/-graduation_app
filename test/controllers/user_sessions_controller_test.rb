require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  test "login page is displayed" do
    get login_path

    assert_response :success
    assert_select "h1", "ログイン"
    assert_select "form[action=?][method=?]", login_path, "post"
  end

  test "logs in with valid credentials" do
    post login_path, params: {
      email: users(:kaori).email,
      password: "password123"
    }

    assert_redirected_to transportation_memos_path
    follow_redirect!
    assert_response :success
    assert_select "h1", "交通費メモ一覧"
    assert_select "form[action=?][method=?]", logout_path, "post"
    assert_select "input[name=?][value=?]", "_method", "delete"
    assert_equal users(:kaori).id.to_s, session[:user_id]
  end

  test "does not log in with invalid credentials" do
    post login_path, params: {
      email: users(:kaori).email,
      password: "wrongpassword"
    }

    assert_response :unprocessable_entity
    assert_nil session[:user_id]
    assert_select ".alert", /メールアドレスまたはパスワードが正しくありません/
  end

  test "logs out current user" do
    post login_path, params: {
      email: users(:kaori).email,
      password: "password123"
    }
    assert_equal users(:kaori).id.to_s, session[:user_id]

    delete logout_path

    assert_redirected_to root_path
    assert_nil session[:user_id]
    assert_equal "ログアウトしました。", flash[:notice]
  end
end
