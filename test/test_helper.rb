ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
# require_relative "../app/services/simple_authorization"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

# https://github.com/heartcombo/devise?tab=readme-ov-file#integration-tests
module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end