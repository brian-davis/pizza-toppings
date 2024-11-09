require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "user authentication and redirect to home#index" do
    get home_index_path
    assert_response :redirect
    assert_redirected_to new_user_session_path

    sign_in users(:chef1)
    get home_index_path

    assert_response :success

    assert_select '#user-header > div:nth-child(3) > form[action="/users/sign_out"] > button', "Sign Out"
  end

  test "user sees dashboard" do
    sign_in users(:chef1)
    get home_index_path
    assert_response :success
    assert_select "h3.dashboard-header", "Dashboard"
  end
end