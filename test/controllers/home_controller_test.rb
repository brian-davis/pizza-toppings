require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "user authentication and redirect to home#index" do
    get home_index_path
    assert_response :redirect
    assert_redirected_to new_user_session_path

    sign_in users(:chef1)
    get home_index_path

    assert_response :success

    assert_select 'body > #user-header > form[action="/users/sign_out"] > button', "Sign Out"
  end

  test "user sees dashboard appropriate for role, chef user" do
    sign_in users(:chef1)
    get home_index_path
    assert_response :success
    assert_select "h1.dashboard-header", "Chef Dashboard"
  end

  test "user sees dashboard appropriate for role, owner user" do
    sign_in users(:owner1)
    get home_index_path
    assert_response :success
    assert_select "h1.dashboard-header", "Owner Dashboard"
  end

  test "user sees dashboard items appropriate for role, chef user" do
    sign_in users(:chef1)
    get home_index_path
    assert_response :success

    expected_item1 = pizzas(:pizza1) # build fixture
    expected_item2 = pizzas(:pizza2) # build fixture

    assert_select "h2.dashboard-items-header", "Pizzas"
    assert_select "div.dashboard-items-list"
    assert_select "div.pizza#pizza_#{expected_item1.id}", "Margherita"
    assert_select "div.pizza#pizza_#{expected_item2.id}", "Napoletana"
  end

  test "user sees user-scoped dashboard items, chef user" do
    sign_in users(:chef1)
    get home_index_path
    assert_response :success

    expected_item1 = pizzas(:pizza1) # build fixture
    expected_item2 = pizzas(:pizza2) # build fixture
    user2_expected_item = pizzas(:pizza3) # build fixture, scoped to chef2

    assert_select "div.pizza#pizza_#{expected_item1.id}", "Margherita"
    assert_select "div.pizza#pizza_#{expected_item2.id}", "Napoletana"

    sign_out users(:chef1)
    sign_in users(:chef2)
    get home_index_path
    assert_response :success

    assert_select "div.pizza#pizza_#{user2_expected_item.id}", "Chicago Style"
  end

  test "user sees dashboard items appropriate for role, owner user" do
    sign_in users(:owner1)
    get home_index_path
    assert_response :success

    expected_item1 = toppings(:topping1) # build fixture
    expected_item2 = toppings(:topping2) # build fixture

    assert_select "h2.dashboard-items-header", "Pizza Toppings"
    assert_select "div.dashboard-items-list"
    assert_select "div.topping#topping_#{expected_item1.id}", "Pepperoni"
    assert_select "div.topping#topping_#{expected_item2.id}", "Sausage"
  end
end