require "test_helper"

class ToppingTest < ActiveSupport::TestCase
  test "topping name string is required" do
    topping1 = Topping.new({ name: "olives", owner: users(:owner1) })
    assert topping1.valid?

    topping2 = Topping.new()
    refute topping2.valid?

    expected = "Name can't be blank".downcase
    result = topping2.errors.full_messages.to_sentence
    assert result.downcase.match?(Regexp.new(expected))
  end

  test "topping owner user is required" do
    topping = Topping.new({ name: "Pineapple" })
    refute topping.valid?

    expected = "Owner must exist".downcase
    result = topping.errors.full_messages.to_sentence
    assert result.downcase.match?(Regexp.new(expected))

    topping.owner = users(:owner1)
    assert topping.valid?
  end

  test "topping name must be unique, scoped to owner user" do
    topping1 = Topping.new({
      name: toppings(:topping1).name,
      owner: users(:owner1)
    })
    refute topping1.valid?

    expected = "Name has already been taken".downcase
    result = topping1.errors.full_messages.to_sentence
    assert result.downcase.match?(Regexp.new(expected))

    topping2 = Topping.new({
      name: toppings(:topping1).name,
      owner: users(:owner2)
    })
    assert topping2.valid?
  end

  test "topping belongs_to owner" do
    c1 = users(:owner1)
    p1 = toppings(:topping1)
    assert_equal c1, p1.owner
    assert p1.in?(c1.toppings)
  end

  test "topping validates owner role" do
    u1 = users(:chef1)
    p1 = Topping.new({
      name: "Basil",
      owner: u1
    })
    refute p1.valid?
  end
end
