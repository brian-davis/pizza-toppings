require "test_helper"

class PizzaToppingTest < ActiveSupport::TestCase
  require "test_helper"

  test "pizza has_and_belongs_to_many toppings" do
    p1 = pizzas(:pizza1) # chef1 -> owner1
    t1 = toppings(:topping1) # owner1

    assert_empty p1.toppings
    assert_empty t1.pizzas

    p1.toppings << t1

    assert t1.in?(p1.toppings)
    assert p1.in?(t1.pizzas)
  end

  test "pizza has_and_belongs_to_many toppings, validates topping on associated owner" do
    p1 = pizzas(:pizza1) # chef1 -> owner1
    c1 = p1.chef
    o1 = c1.manager

    t1 = toppings(:topping3) # owner2

    assert_empty p1.toppings
    assert_empty t1.pizzas

    assert_raises ActiveRecord::RecordInvalid do
      p1.toppings << t1
    end

    refute t1.in?(p1.toppings)
    refute p1.in?(t1.pizzas)
  end

  test "PizzaTopping uniqueness" do
    p1 = pizzas(:pizza1) # chef1 -> owner1
    t1 = toppings(:topping1) # owner1

    assert_empty p1.toppings
    assert_empty t1.pizzas

    p1.toppings << t1

    assert t1.in?(p1.toppings)
    assert p1.in?(t1.pizzas)

    assert_raises ActiveRecord::RecordInvalid do
      # already there
      p1.toppings << t1
    end
  end
end
