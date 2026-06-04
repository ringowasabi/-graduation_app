require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with name password and password confirmation" do
    user = User.new(
      name: "山田太郎",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
  end

  test "requires name" do
    user = User.new(password: "password123", password_confirmation: "password123")

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "requires unique name" do
    user = User.new(
      name: users(:kaori).name,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not user.valid?
    assert_includes user.errors[:name], "has already been taken"
  end

  test "strips name before validation" do
    user = User.new(
      name: "  山田太郎  ",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
    assert_equal "山田太郎", user.name
  end

  test "generates internal email when email is blank" do
    user = User.new(
      name: "山田太郎",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
    assert_match(/\Auser-.+@example\.invalid\z/, user.email)
  end
end
