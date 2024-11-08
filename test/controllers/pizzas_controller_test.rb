require "test_helper"

class PizzasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pizza = pizzas(:pizza1)
    @user = users(:chef1)
    sign_in @user
  end

  test "should get index" do
    get pizzas_url
    assert_response :redirect # REFACTOR: currently handled by home#index
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
