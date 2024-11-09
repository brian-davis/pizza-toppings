require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:owner1)
    get employees_index_url
    assert_response :success
  end

  test "should get show" do
    o1 = users(:owner1)
    e1 = users(:chef1)
    sign_in o1
    get employee_url(e1)
    assert_response :success
  end
end
