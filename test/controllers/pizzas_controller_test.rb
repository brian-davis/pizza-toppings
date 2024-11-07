require "test_helper"

class PizzasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pizza = pizzas(:pizza1)
  end

  test "should get index" do
    sign_in users(:chef1)
    get pizzas_url
    assert_response :redirect # REFACTOR: currently handled by home#index
  end

  test "should get new" do
    sign_in users(:chef1)
    get new_pizza_url
    assert_response :success
  end

  test "should create pizza" do
    assert_difference("Pizza.count") do
      sign_in users(:chef1)

      valid_params = { pizza: {
        name: "Special #{rand(1000)}"
      } }
      post pizzas_url, params: valid_params
    end

    assert_redirected_to pizza_url(Pizza.last)
  end

  test "should show pizza" do
    sign_in users(:chef1)
    get pizza_url(@pizza)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:chef1)
    get edit_pizza_url(@pizza)
    assert_response :success
  end

  test "should update pizza" do
    sign_in users(:chef1)
    patch pizza_url(@pizza), params: { pizza: {
      name: @pizza.name + "UPDATE"
    } }
    assert_redirected_to pizza_url(@pizza)
  end

  test "should destroy pizza" do
    assert_difference("Pizza.count", -1) do
      sign_in users(:chef1)
      delete pizza_url(@pizza)
    end

    assert_redirected_to pizzas_url
  end
end
