source :rubygems

gem "rails", "3.1.1"
gem "mongoid"
gem "bson_ext"
gem "simple_form"

#gem "on_the_spot"
gem 'best_in_place', '1.0.4.preMongo',  path: '~/projects/github/best_in_place/'
gem "breadcrumbs_on_rails"
gem 'redcarpet'
gem 'mongoid_slug'

gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'

gem 'faker'
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
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'growl_notify'
  gem "spork", "~> 0.9.0.rc9"
  gem "capybara"

  gem 'mongoid-rspec'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem "guard-spork"
end
