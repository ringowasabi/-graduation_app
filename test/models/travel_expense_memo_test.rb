require "test_helper"

class TravelExpenseMemoTest < ActiveSupport::TestCase
  test "valid with destination places and one way fare" do
    memo = destinations(:activity_place).travel_expense_memos.build(
      departure_place: "池袋",
      arrival_place: "新宿",
      one_way_fare: 210
    )

    assert memo.valid?
  end

  test "invalid without required attributes" do
    memo = TravelExpenseMemo.new

    assert memo.invalid?
    assert_includes memo.errors[:destination], "must exist"
    assert_includes memo.errors[:departure_place], "can't be blank"
    assert_includes memo.errors[:arrival_place], "can't be blank"
    assert_includes memo.errors[:one_way_fare], "can't be blank"
  end

  test "invalid with non positive fare" do
    memo = destinations(:activity_place).travel_expense_memos.build(
      departure_place: "池袋",
      arrival_place: "新宿",
      one_way_fare: 0
    )

    assert memo.invalid?
  end

  test "strips places before validation" do
    memo = destinations(:activity_place).travel_expense_memos.build(
      departure_place: "  池袋  ",
      arrival_place: "  新宿  ",
      one_way_fare: 210
    )

    assert memo.valid?
    assert_equal "池袋", memo.departure_place
    assert_equal "新宿", memo.arrival_place
  end

  test "returns round trip fare from one way fare" do
    assert_equal 900, travel_expense_memos(:shibuya_route).round_trip_fare
  end

  test "does not have round trip fare column" do
    assert_not_includes TravelExpenseMemo.column_names, "round_trip_fare"
  end
end
