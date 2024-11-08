require "test_helper"

class SimpleAuthorizationTest < ActiveSupport::TestCase
  require "test_helper"

  test "simple role authorization, authorized user" do
    assert_nil SimpleAuthorization.role_auth(:owner, users(:owner1))
    assert_nil SimpleAuthorization.role_auth(:chef, users(:chef1))
  end

  test "simple role authorization, unauthorized user" do
    assert_raises SimpleAuthorization::UnauthorizedError do
      SimpleAuthorization.role_auth(:chef, users(:owner1))
    end

    assert_raises SimpleAuthorization::UnauthorizedError do
      SimpleAuthorization.role_auth(:owner, users(:chef1))
    end
  end
end