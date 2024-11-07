require "test_helper"

class PizzaTest < ActiveSupport::TestCase
  test "pizza name string is required" do
    pizza1 = Pizza.create({ name: "Special" })
    assert pizza1.valid?

    pizza2 = Pizza.new()
    refute pizza2.valid?
    expected = "Name can't be blank"
    result = pizza2.errors.full_messages.to_sentence
    assert_equal expected, result
  end

  test "pizza name must be unique" do
    pizza = Pizza.new({ name: pizzas(:one).name }) # Margherita
    refute pizza.valid?
    expected = "Name has already been taken"
    result = pizza.errors.full_messages.to_sentence
    assert_equal expected, result
  end
end
