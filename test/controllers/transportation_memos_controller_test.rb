require "test_helper"

class TransportationMemosControllerTest < ActionDispatch::IntegrationTest
  test "index page displays only current user's transportation memos" do
    login_as_kaori

    get transportation_memos_path

    assert_response :success
    assert_select "h1", "交通費メモ一覧"
    assert_select "td", destinations(:activity_place).name
    assert_select "td", "新宿"
    assert_select "td", "渋谷"
    assert_select "td", "450円"
    assert_select "td", "900円"
    assert_no_match destinations(:other_activity_place).name, response.body
    assert_select "a[href=?]", new_transportation_memo_path
    assert_select "a[href=?]", transportation_memo_path(travel_expense_memos(:shibuya_route))
    assert_select "a[href=?]", edit_transportation_memo_path(travel_expense_memos(:shibuya_route))
  end

  test "index page displays empty state" do
    login_as_hanako_without_memos

    get transportation_memos_path

    assert_response :success
    assert_select "p", /交通費メモはまだ登録されていません/
    assert_select "a[href=?]", new_transportation_memo_path
  end

  test "show page displays current user's transportation memo" do
    login_as_kaori
    memo = travel_expense_memos(:shibuya_route)

    get transportation_memo_path(memo)

    assert_response :success
    assert_select "h1", "交通費メモ詳細"
    assert_select "dd", destinations(:activity_place).name
    assert_select "dd", "新宿"
    assert_select "dd", "渋谷"
    assert_select "dd", "450円"
    assert_select "dd", "900円"
    assert_select "a[href=?]", edit_transportation_memo_path(memo)
    assert_select "a[href=?]", transportation_memos_path
  end

  test "does not show another user's transportation memo" do
    login_as_kaori

    get transportation_memo_path(travel_expense_memos(:other_route))

    assert_response :not_found
  end

  test "edit page displays current user's transportation memo values" do
    login_as_kaori
    memo = travel_expense_memos(:shibuya_route)

    get edit_transportation_memo_path(memo)

    assert_response :success
    assert_select "h1", "交通費メモ編集"
    assert_select "form[action=?]", transportation_memo_path(memo)
    assert_select "input[name=?][value=?]", "travel_expense_memo[departure_place]", "新宿"
    assert_select "input[name=?][value=?]", "travel_expense_memo[arrival_place]", "渋谷"
    assert_select "input[name=?][value=?]", "travel_expense_memo[one_way_fare]", "450"
  end

  test "updates transportation memo with valid params" do
    login_as_kaori
    memo = travel_expense_memos(:shibuya_route)

    patch transportation_memo_path(memo), params: {
      travel_expense_memo: {
        destination_id: destinations(:activity_place).id,
        departure_place: "池袋",
        arrival_place: "品川",
        one_way_fare: 320
      }
    }

    assert_redirected_to transportation_memo_path(memo)
    assert_equal "交通費メモを更新しました。", flash[:notice]
    memo.reload
    assert_equal "池袋", memo.departure_place
    assert_equal "品川", memo.arrival_place
    assert_equal 320, memo.one_way_fare

    follow_redirect!
    assert_select "dd", "640円"
  end

  test "does not update transportation memo with invalid params" do
    login_as_kaori
    memo = travel_expense_memos(:shibuya_route)

    patch transportation_memo_path(memo), params: {
      travel_expense_memo: {
        destination_id: destinations(:activity_place).id,
        departure_place: "",
        arrival_place: "",
        one_way_fare: ""
      }
    }

    assert_response :unprocessable_entity
    assert_select ".alert", /入力内容を確認してください/
    memo.reload
    assert_equal "新宿", memo.departure_place
    assert_equal "渋谷", memo.arrival_place
    assert_equal 450, memo.one_way_fare
  end

  test "does not edit another user's transportation memo" do
    login_as_kaori

    get edit_transportation_memo_path(travel_expense_memos(:other_route))

    assert_response :not_found
  end

  test "does not update another user's transportation memo" do
    login_as_kaori
    memo = travel_expense_memos(:other_route)

    patch transportation_memo_path(memo), params: {
      travel_expense_memo: {
        destination_id: destinations(:activity_place).id,
        departure_place: "横浜",
        arrival_place: "川崎",
        one_way_fare: 999
      }
    }

    assert_response :not_found
    memo.reload
    assert_equal "池袋", memo.departure_place
    assert_equal "上野", memo.arrival_place
    assert_equal 320, memo.one_way_fare
  end

  test "destroys current user's transportation memo" do
    login_as_kaori

    assert_difference "TravelExpenseMemo.count", -1 do
      delete transportation_memo_path(travel_expense_memos(:shibuya_route))
    end

    assert_redirected_to transportation_memos_path
    assert_equal "交通費メモを削除しました。", flash[:notice]
  end

  test "does not destroy another user's transportation memo" do
    login_as_kaori

    assert_no_difference "TravelExpenseMemo.count" do
      delete transportation_memo_path(travel_expense_memos(:other_route))
    end

    assert_response :not_found
  end

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
    assert_select ".completion-message-card[role=?]", "img"
    assert_select "a[href=?]", transportation_memos_path, text: "一覧へ戻る"
    assert_select "a[href=?]", new_transportation_memo_path, text: "続けて登録する"
  end

  private

  def login_as_kaori
    post login_path, params: {
      email: users(:kaori).email,
      password: "password123"
    }
  end

  def login_as_hanako_without_memos
    travel_expense_memos(:other_route).destroy!

    post login_path, params: {
      email: users(:hanako).email,
      password: "password123"
    }
  end
end
