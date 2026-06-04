require "test_helper"

class TransportationMemosControllerTest < ActionDispatch::IntegrationTest
  test "redirects guest to login page" do
    get transportation_memos_path

    assert_redirected_to login_path
    assert_equal "ログインしてください。", flash[:alert]
  end
end
