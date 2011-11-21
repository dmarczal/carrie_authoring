source :rubygems

gem "rails", "3.1.1"
gem "mongoid"
gem "bson_ext"
gem "simple_form"
gem "thin"

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'spine-rails'
  gem 'eco'
end

gem 'jquery-rails'

group :development, :test do
  gem "awesome_print", :require => false
  gem "pry", :require => false
  gem "rspec-rails"
  gem "rb-fsevent"
end

group :test do
  gem "factory_girl"
  gem "factory_girl-preload"
  gem "test_notifier", :require => "test_notifier/runner/rspec"
  gem "spork", "~> 0.9.0.rc9"
  gem "capybara"
end
