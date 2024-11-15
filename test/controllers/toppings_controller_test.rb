require "test_helper"

class ToppingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @topping = toppings(:topping1)
    sign_in users(:owner1)
  end

  test "should get index" do
    sign_in users(:owner1)
    get toppings_path
    assert_response :success

    expected_item1 = toppings(:topping1) # build fixture
    expected_item2 = toppings(:topping2) # build fixture

    assert_select "h3", "Toppings"
    assert_select "div.list"
    assert_select "div.list-item#topping_#{expected_item1.id}"
    assert_select "div.list-item#topping_#{expected_item2.id}"
  end

  test "should get new" do
    get new_topping_url
    assert_response :success
  end

  test "should create topping" do
    assert_difference("Topping.count") do
      post toppings_url, params: { topping: {
        name: "New Topping #{rand(1000)}"
      } }
    end

    assert_redirected_to topping_url(Topping.last)
  end

  test "should show topping" do
    get topping_url(@topping)
    assert_response :success
  end

  test "should get edit" do
    get edit_topping_url(@topping)
    assert_response :success
  end

  test "should update topping" do
    patch topping_url(@topping), params: { topping: {
      name: @topping.name + "UPDATE"
    } }
    assert_redirected_to topping_url(@topping)
  end

  test "should destroy topping" do
    assert_difference("Topping.count", -1) do
      delete topping_url(@topping)
    end

    assert_redirected_to toppings_url
  end

  test "user cannot navigate to page inappropriate for role" do
    sign_in users(:chef1)
    get new_topping_path
    assert_response :redirect
    assert_equal root_url, response.headers["location"]
  end
end
