require "test_helper"

class PizzaToppingTest < ActiveSupport::TestCase
  require "test_helper"

  test "pizza has_and_belongs_to_many toppings" do
    pizza = pizzas(:pizza1) # chef1 -> owner1
    topping = toppings(:topping4) # owner1, pizza1

    assert topping.in?(pizza.toppings) # built by fixture
    assert pizza.in?(topping.pizzas)
  end

  test "pizza has_and_belongs_to_many toppings, validates topping on associated owner" do
    p1 = pizzas(:pizza1) # chef1 -> owner1
    c1 = p1.chef
    o1 = c1.manager

    t1 = toppings(:topping3) # owner2

    assert_raises ActiveRecord::RecordInvalid do
      p1.toppings << t1
    end

    refute t1.in?(p1.toppings)
    refute p1.in?(t1.pizzas)
  end

  test "PizzaTopping uniqueness" do
    pizza = pizzas(:pizza1) # chef1 -> owner1
    topping = toppings(:topping4)

    assert_raises ActiveRecord::RecordInvalid do
      # already there
      pizza.toppings << topping
    end
  end
end
