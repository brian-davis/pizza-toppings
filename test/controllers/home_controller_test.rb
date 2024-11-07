require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "user authentication and redirect to home#index" do
    get home_index_path
    assert_response :redirect
    assert_redirected_to new_user_session_path

    sign_in users(:one)
    get home_index_path

    assert_response :success

    assert_select 'body > form[action="/users/sign_out"] > button', 'Sign Out'
  end
end