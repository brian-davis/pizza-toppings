require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "role enum" do
    expected = {"owner"=>0, "chef"=>1}
    result = User.roles
    assert_equal expected, result
  end

  test "user role queries" do
    assert users(:chef1).role_chef?
    assert users(:owner1).role_owner?
  end

  test "user hierarchy relations" do
    manager = users(:owner1)
    employee = users(:chef1)

    assert_equal manager, employee.manager
    assert employee.in?(manager.employees)
  end

  test "user hierarchy can be blank" do
    new_manager = User.create(email: "new_manager@example.com", role: :owner)
    assert_empty new_manager.employees

    new_employee = User.create(email: "new_manager@example.com", role: :chef)
    assert_nil new_employee.manager
  end

  test "user (chef) has_many pizzas" do
    o1 = users(:owner1)
    c1 = users(:chef1)
    u2 = users(:chef2)
    p1 = pizzas(:pizza1)

    assert_equal c1, p1.chef
    assert p1.in?(c1.pizzas)
    refute p1.in?(u2.pizzas)

    assert_empty o1.pizzas
  end

  test "user (owner) has_many toppings" do
    o1 = users(:owner1)
    o2 = users(:owner2)
    c1 = users(:chef1)
    t1 = toppings(:topping1)

    assert_equal o1, t1.owner

    assert t1.in?(o1.toppings)
    refute t1.in?(o2.toppings)

    assert_empty c1.toppings
  end

  test "chef_toppings" do
    c1 = users(:chef1)
    o1 = users(:owner1)

    # chef role delegates to manager
    assert_equal o1.toppings, c1.chef_toppings

    # manager role n/a
    assert_nil o1.chef_toppings
  end
end
