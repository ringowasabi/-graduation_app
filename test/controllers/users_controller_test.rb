require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "new user page is displayed" do
    get signup_path

    assert_response :success
    assert_select "h1", "新規登録"
    assert_select "form[action=?][method=?]", users_path, "post"
  end

  test "creates user with valid params" do
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          name: "山田太郎",
          email: "taro@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to login_path
    assert_equal "ユーザー登録が完了しました。ログインしてください。", flash[:notice]
  end

  test "does not create user with duplicate email" do
    assert_no_difference "User.count" do
      post users_path, params: {
        user: {
          name: "重複ユーザー",
          email: users(:kaori).email,
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert", /入力内容を確認してください/
  end

  test "does not create user with blank required params" do
    assert_no_difference "User.count" do
      post users_path, params: {
        user: {
          name: "",
          email: "",
          password: "",
          password_confirmation: ""
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert", /入力内容を確認してください/
  end
end
