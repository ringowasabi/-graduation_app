require "test_helper"

class TransportationMemosControllerTest < ActionDispatch::IntegrationTest
  test "redirects guest from new page to login page" do
    get new_transportation_memo_path

    assert_redirected_to login_path
    assert_equal "ログインしてください。", flash[:alert]
  end

  test "new transportation memo page is displayed for logged in user" do
    login_as_kaori

    get new_transportation_memo_path

    assert_response :success
    assert_select "h1", "交通費メモ登録"
    assert_select "form[action=?][method=?]", transportation_memos_path, "post"
    assert_select "select[name=?]", "travel_expense_memo[destination_id]"
    assert_select "option", destinations(:activity_place).name
  end

  test "creates transportation memo with valid params" do
    login_as_kaori

    assert_difference "TravelExpenseMemo.count", 1 do
      post transportation_memos_path, params: {
        travel_expense_memo: {
          destination_id: destinations(:activity_place).id,
          departure_place: "池袋",
          arrival_place: "新宿",
          one_way_fare: 210
        }
      }
    end

    memo = TravelExpenseMemo.order(:created_at).last
    assert_equal destinations(:activity_place), memo.destination
    assert_redirected_to transportation_memo_completion_path
    assert_equal "交通費メモを登録しました。", flash[:notice]
  end

  test "does not create transportation memo with blank params" do
    login_as_kaori

    assert_no_difference "TravelExpenseMemo.count" do
      post transportation_memos_path, params: {
        travel_expense_memo: {
          destination_id: "",
          departure_place: "",
          arrival_place: "",
          one_way_fare: ""
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert", /入力内容を確認してください/
  end

  test "does not create transportation memo with another user's destination" do
    login_as_kaori

    assert_no_difference "TravelExpenseMemo.count" do
      post transportation_memos_path, params: {
        travel_expense_memo: {
          destination_id: destinations(:other_activity_place).id,
          departure_place: "池袋",
          arrival_place: "新宿",
          one_way_fare: 210
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert", /入力内容を確認してください/
  end

  test "completion page is displayed for logged in user" do
    login_as_kaori

    get transportation_memo_completion_path

    assert_response :success
    assert_select "h1", "登録完了！今日の営業もがんばりましょう！"
  end

  private

  def login_as_kaori
    post login_path, params: {
      email: users(:kaori).email,
      password: "password123"
    }
  end
end
