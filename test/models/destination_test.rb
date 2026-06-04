require "test_helper"

class DestinationTest < ActiveSupport::TestCase
  test "valid with user and name" do
    destination = users(:kaori).destinations.build(name: "活動先B")

    assert destination.valid?
  end

  test "invalid without name" do
    destination = users(:kaori).destinations.build(name: "")

    assert destination.invalid?
  end

  test "invalid with duplicate name for same user" do
    destination = users(:kaori).destinations.build(name: destinations(:activity_place).name)

    assert destination.invalid?
  end

  test "valid with same name for different user" do
    destination = users(:hanako).destinations.build(name: destinations(:activity_place).name)

    assert destination.valid?
  end

  test "strips name before validation" do
    destination = users(:kaori).destinations.build(name: "  活動先B  ")

    assert destination.valid?
    assert_equal "活動先B", destination.name
  end
end
