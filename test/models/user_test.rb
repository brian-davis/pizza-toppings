require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "role enum" do
    expected = {"owner"=>0, "chef"=>1}
    result = User.roles
    assert_equal expected, result
  end

  test "user role queries" do
    assert users(:one).role_chef?
    assert users(:two).role_owner?
  end
end
