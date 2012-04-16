source :rubygems

gem "rails", "3.2.1"
gem "mongoid"
gem "bson_ext"
gem "simple_form"
gem "devise"
gem "cancan"
gem "truncate_html", "~> 0.5.1"

gem 'best_in_place', '1.0.6.preMongo', git: 'git://github.com/dmarczal/best_in_place.git'

gem "breadcrumbs_on_rails"
gem 'redcarpet'
gem 'mongoid_slug'
gem 'kaminari'

gem "twitter-bootstrap-rails", "~> 2.0rc0"
gem 'gravatar_image_tag'

gem 'faker'
gem "thin"

gem "ckeditor", "3.7.0.rc3"
gem 'mongoid-paperclip', :require => 'mongoid_paperclip'

gem 'mathjax-rails', git: 'git://github.com/sharespost/mathjax-rails.git'

group :assets do
  gem 'sass-rails', "~> 3.2.3"
  gem 'uglifier', ">= 1.0.3"
end

gem 'jquery-rails'

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano'

group :development, :test do
  gem "awesome_print", :require => false
  gem "pry", :require => false
  gem "rspec-rails"
  gem 'jasmine-rails'
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
