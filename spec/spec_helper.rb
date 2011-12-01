require 'rubygems'
require "spork"

Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)
  require "rspec/rails"
  require 'capybara/rspec'
  require 'database_cleaner'

  RSpec.configure do |config|
    #config.use_transactional_fixtures = true
    config.mock_with :rspec
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
    config.include Mongoid::Matchers
  end
  ActiveSupport::Dependencies.clear
end

Spork.each_run do
  DatabaseCleaner.orm = "mongoid"
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Rails.application.reload_routes!
  Fabrication.clear_definitions
  DatabaseCleaner.clean
end
