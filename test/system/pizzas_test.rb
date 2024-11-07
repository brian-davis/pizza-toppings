require "application_system_test_case"

class PizzasTest < ApplicationSystemTestCase
  setup do
    @pizza = pizzas(:one)
  end

  test "visiting the index" do
    visit pizzas_url
    assert_selector "h1", text: "Pizzas"
  end

  test "should create pizza" do
    visit pizzas_url
    click_on "New pizza"

    click_on "Create Pizza"

    assert_text "Pizza was successfully created"
    click_on "Back"
  end

  test "should update Pizza" do
    visit pizza_url(@pizza)
    click_on "Edit this pizza", match: :first

    click_on "Update Pizza"

    assert_text "Pizza was successfully updated"
    click_on "Back"
  end

  test "should destroy Pizza" do
    visit pizza_url(@pizza)
    click_on "Destroy this pizza", match: :first

    assert_text "Pizza was successfully destroyed"
  end
end
