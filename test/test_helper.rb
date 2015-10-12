ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "feature_test_helper"
require "test_helper_requests"
require "minitest/reporters"


reporter_options = { color: true }
Minitest::Reporters.use!(
  [Minitest::Reporters::DefaultReporter.new(reporter_options)])

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end
Capybara.default_max_wait_time = 30


if ENV["SELENIUM_BROWSER"] == "chrome"
  Capybara.default_driver  = :selenium_chrome
else
  Capybara.default_driver  = :selenium_firefox
end

if ENV["TEST_AGAINST_HEROKU"]
  # TODO: set to URL of deployed demo app
  # Capybara.app_host    =
else
  Capybara.app_host    = "http://0.0.0.0:3001"
  Capybara.server_port = 3001
end

class ActiveSupport::TestCase
  fixtures :all
end
