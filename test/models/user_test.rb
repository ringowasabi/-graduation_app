require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with name email password and password confirmation" do
    user = User.new(
      name: "山田太郎",
      email: "taro@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
  end

  test "requires name" do
    user = User.new(email: "taro@example.com", password: "password123", password_confirmation: "password123")

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "requires unique email case insensitively" do
    user = User.new(
      name: "別ユーザー",
      email: users(:kaori).email.upcase,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "normalizes email before validation" do
    user = User.new(
      name: "山田太郎",
      email: " TARO@example.COM ",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
    assert_equal "taro@example.com", user.email
  end
end
