source :rubygems

gem "rails", "3.1.1"
gem "mongoid"
gem "bson_ext"
gem "simple_form"

gem 'best_in_place', '1.0.4.preMongo', git: 'git@github.com:dmarczal/best_in_place.git'

gem "breadcrumbs_on_rails"
gem 'redcarpet'
gem 'mongoid_slug'
gem 'kaminari'

gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'

gem 'faker'
gem "thin"

group :assets do
  gem 'sass-rails'
#  gem 'coffee-rails'
  gem 'uglifier'
  gem 'spine-rails'
  gem 'eco'
end

gem 'jquery-rails'

group :development, :test do
  gem "awesome_print", :require => false
  gem "pry", :require => false
  gem "rspec-rails"
  #gem "rb-fsevent"
end


group :test do
  gem 'database_cleaner'
  gem 'fabrication'
#  gem "test_notifier", :require => "test_notifier/runner/rspec"
#  gem 'growl_notify'
  gem "spork", "~> 0.9.0.rc9"
  gem "capybara"

  gem 'mongoid-rspec'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem "guard-spork"
end
