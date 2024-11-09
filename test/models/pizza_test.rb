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
    assert_equal"pepperoni, sausage, special cheese, and tomato", pizza.topping_list
  end

  test "build associated toppings" do
    c1 = users(:chef1)
    toppings = c1.chef_toppings
    pizza = c1.pizzas.new(name: "Everything", toppings: toppings)
    assert pizza.valid?
    pizza.save
    assert_equal pizza.pizza_toppings.count, toppings.count
  end

  test "cannot build pizza with duplicate toppings" do
    c1 = users(:chef1)
    toppings = c1.chef_toppings
    pizza = c1.pizzas.create(name: "New Pizza 1", toppings: toppings)
    pizza2 = c1.pizzas.new(name: "New Pizza 2", toppings: toppings)
    refute pizza2.valid?
    expected = "A pizza already exists with these toppings."
    assert_equal expected, pizza2.errors.full_messages.to_sentence
  end

  test "cannot build pizza with duplicate toppings, empty toppings special case" do
    c1 = users(:chef1)
    pizza = c1.pizzas.create(name: "New Pizza 1")

    # The first 'no toppings' pizza is ok.
    assert pizza.valid?
    assert_empty pizza.toppings

    # The next 'no toppings' pizza is a duplicate.
    pizza2 = c1.pizzas.new(name: "New Pizza 2")
    refute pizza2.valid?
    expected = "A pizza already exists with these toppings."
    assert_equal expected, pizza2.errors.full_messages.to_sentence
  end

  test "cannot build pizza with duplicate toppings, marked_for_destruction special case" do
    c1 = users(:chef1)
    pizza1 = pizzas(:pizza1) # chef1, topping4
    t4 = toppings(:topping4)
    t5 = toppings(:topping5)
    assert t4.in?(pizza1.toppings)
    refute t5.in?(pizza1.toppings)

    # build a similar pizza, with more toppings
    pizza2 = c1.pizzas.create(name: "edge case", toppings:[
      t4, t5
    ])
    assert pizza2.valid?
    assert t4.in?(pizza2.toppings)
    assert t5.in?(pizza2.toppings)

    # Update, to remove the extra topping, so that the only remaining topping is a duplicate
    params = ActionController::Parameters.new({
      pizza: {
        pizza_toppings_attributes: {
          "0" => {
            "id" => pizza2.pizza_toppings.find_by(topping_id: t4.id).id,
            "_destroy" => "0"
          },
          "1" => {
            "id" => pizza2.pizza_toppings.find_by(topping_id: t5.id).id,
            "_destroy" => "1"
          }
        }
      }
    }).require(:pizza).permit(:id, :name, pizza_toppings_attributes: [:id, :_destroy])
    refute pizza2.update(params)
  end
end
