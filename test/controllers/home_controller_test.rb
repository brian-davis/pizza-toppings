require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "user authentication and redirect to home#index" do
    get home_index_path
    assert_response :redirect
    assert_redirected_to new_user_session_path

    sign_in users(:chef)
    get home_index_path

    assert_response :success

    assert_select 'body > form[action="/users/sign_out"] > button', "Sign Out"
  end

  test "user sees dashboard appropriate for role, chef user" do
    sign_in users(:chef)
    get home_index_path
    assert_response :success
    assert_select "h1.dashboard-header", "Chef Dashboard"
  end

  test "user sees dashboard appropriate for role, owner user" do
    sign_in users(:owner)
    get home_index_path
    assert_response :success
    assert_select "h1.dashboard-header", "Owner Dashboard"
  end
end