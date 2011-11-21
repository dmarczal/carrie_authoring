require "spork"

Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)
  require "rspec/rails"

  RSpec.configure do |config|
    config.use_transactional_fixtures = true
    config.mock_with :rspec
  end

  ActiveSupport::Dependencies.clear
end

Spork.each_run do
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Rails.application.reload_routes!
end
