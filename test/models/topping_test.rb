require "test_helper"

class ToppingTest < ActiveSupport::TestCase
  test "topping name string is required" do
    topping1 = Topping.create({ name: "olives" })
    assert topping1.valid?

    topping2 = Topping.new()
    refute topping2.valid?
    expected = "Name can't be blank"
    result = topping2.errors.full_messages.to_sentence
    assert_equal expected, result
  end

  test "topping name must be unique" do
    topping = Topping.new({ name: toppings(:one).name }) # pepperoni
    refute topping.valid?
    expected = "Name has already been taken"
    result = topping.errors.full_messages.to_sentence
    assert_equal expected, result
  end
end
