require "test_helper"

class PizzasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pizza = pizzas(:pizza1)
    @user = users(:chef1)
    sign_in @user
  end

  test "should get index" do
    sign_in users(:chef1)
    get pizzas_path
    assert_response :success

    expected_item1 = pizzas(:pizza1) # build fixture
    expected_item2 = pizzas(:pizza2) # build fixture

    assert_select "h3", "Pizzas"
    assert_select "div.list"
    assert_select "div.list-item#pizza_#{expected_item1.id}"
    assert_select "div.list-item#pizza_#{expected_item2.id}"
  end

  test "user sees user-scoped dashboard items, chef user" do
    # user-scoping
    sign_in users(:chef2)

    user2_expected_item = pizzas(:pizza3) # build fixture, scoped to chef2
    get pizzas_path
    assert_response :success

    assert_select "div.list-item#pizza_#{user2_expected_item.id}"
  end

  test "should get new" do
    get new_pizza_url
    assert_response :success
  end

  test "should create pizza" do
    assert_difference("Pizza.count") do
      valid_params = { pizza: {
        name: "Special #{rand(1000)}"
      } }
      post pizzas_url, params: valid_params
    end

    assert_redirected_to pizza_url(Pizza.last)
  end

  test "should create pizza with associated toppings" do
    assert_difference("Pizza.count") do
      new_name = "Special #{rand(1000)}"
      valid_params = {
        pizza: {
          name: new_name,
          pizza_toppings_attributes: @user.chef_toppings.pluck(:id).map.with_index { |e, i| [i.to_s, {"topping_id" => e }] }.to_h
        }
      }
      post pizzas_url, params: valid_params
      new_pizza = Pizza.last
      assert_equal new_name, new_pizza.name
      assert_equal @user.chef_toppings.pluck(:id).sort, new_pizza.toppings.pluck(:id).sort
    end

    assert_redirected_to pizza_url(Pizza.last)
  end

  test "should show pizza" do
    get pizza_url(@pizza)
    assert_response :success
  end

  test "should get edit" do
    get edit_pizza_url(@pizza)
    assert_response :success
  end

  test "should update pizza" do
    patch pizza_url(@pizza), params: { pizza: {
      name: @pizza.name + "UPDATE"
    } }
    assert_redirected_to pizza_url(@pizza)
  end

  test "should destroy pizza" do
    assert_difference("Pizza.count", -1) do
      delete pizza_url(@pizza)
    end

    assert_redirected_to pizzas_url
  end

  test "user cannot navigate to page inappropriate for role" do
    sign_in users(:owner1)
    get new_pizza_path
    assert_response :redirect
    assert_equal root_url, response.headers["location"]
  end
end
