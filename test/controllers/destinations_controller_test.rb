require "test_helper"

class DestinationsControllerTest < ActionDispatch::IntegrationTest
  test "redirects guest to login page" do
    get new_destination_path

    assert_redirected_to login_path
    assert_equal "ログインしてください。", flash[:alert]
  end

  test "new destination page is displayed for logged in user" do
    login_as_kaori

    get new_destination_path

    assert_response :success
    assert_select "h1", "訪問先登録"
    assert_select "form[action=?][method=?]", destinations_path, "post"
    assert_select "li", destinations(:activity_place).name
  end

  test "creates destination with valid params" do
    login_as_kaori

    assert_difference "users(:kaori).destinations.count", 1 do
      post destinations_path, params: {
        destination: {
          name: "活動先B"
        }
      }
    end

    assert_redirected_to new_destination_path
    assert_equal "訪問先を登録しました。", flash[:notice]
  end

  test "does not create duplicate destination for same user" do
    login_as_kaori

    assert_no_difference "Destination.count" do
      post destinations_path, params: {
        destination: {
          name: destinations(:activity_place).name
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert", /入力内容を確認してください/
  end

  private

  def login_as_kaori
    post login_path, params: {
      name: users(:kaori).name,
      password: "password123"
    }
  end
end
