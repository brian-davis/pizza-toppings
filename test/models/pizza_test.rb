require "test_helper"

class PizzaTest < ActiveSupport::TestCase
  test "pizza name string is required" do
    pizza1 = Pizza.new({ name: "Special", chef: users(:chef1) })
    assert pizza1.valid?

    pizza2 = Pizza.new()
    refute pizza2.valid?

    expected = "Name can't be blank".downcase
    result = pizza2.errors.full_messages.to_sentence
    assert result.downcase.match?(Regexp.new(expected))
  end

  test "pizza chef user is required" do
    pizza1 = Pizza.new({ name: "Special" })
    refute pizza1.valid?

    expected = "Chef must exist".downcase
    result = pizza1.errors.full_messages.to_sentence
    assert result.downcase.match?(Regexp.new(expected))

    pizza1.chef = users(:chef1)
    assert pizza1.valid?
  end

  test "pizza name must be unique, scoped to chef user" do
    pizza1 = Pizza.new({
      name: pizzas(:pizza1).name,
      chef: users(:chef1)
    })
    refute pizza1.valid?

    expected = "Name has already been taken".downcase
    result = pizza1.errors.full_messages.to_sentence
    assert result.downcase.match?(Regexp.new(expected))

    pizza2 = Pizza.new({
      name: pizzas(:pizza1).name,
      chef: users(:chef2)
    })
    assert pizza2.valid?
  end

  test "pizza belongs_to chef" do
    c1 = users(:chef1)
    p1 = pizzas(:pizza1)
    assert_equal c1, p1.chef
    assert p1.in?(c1.pizzas)
  end

  test "pizza validates chef role" do
    u1 = users(:owner1)
    p1 = Pizza.new({
      name: "Special 2",
      chef: u1
    })
    refute p1.valid?
  end

  test "topping_list" do
    chef = users(:chef1)
    pizza = chef.pizzas.create(name: "Everything")
    chef.chef_toppings.each do |t|
      pizza.toppings << t
    end
    assert_equal "pepperoni and sausage", pizza.topping_list
  end

  test "build associated toppings" do
    c1 = users(:chef1)
    toppings = c1.chef_toppings
    pizza = c1.pizzas.new(name: "Everything", toppings: toppings)
    assert pizza.valid?
    pizza.save
    assert_equal pizza.pizza_toppings.count, toppings.count
  end
end
