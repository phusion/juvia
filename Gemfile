source 'https://rubygems.org'

gem 'rails', '~> 4.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'schema_plus'
gem 'default_value_for'
gem 'bluecloth'
gem 'devise'
gem 'jquery-rails'
gem 'will_paginate'
gem 'cancan'
gem 'rack'
gem 'nokogiri', "~> 1.8.5"
gem 'css3buttons'
gem 'rake', '< 11.0'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

# compatibility gems
gem 'protected_attributes'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
gem 'bcrypt'

group :development do
  gem 'guard-livereload'
  gem 'web-console'
  gem 'spring'

  # Gems used for comment import from WordPress
  # gem 'htmlentities'
  # gem 'sequel'
  # gem 'mysqlplus'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'pry'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'rspec-activemodel-mocks' # for compatibility
  gem 'capybara', '~> 2.2.0', :require => false
  gem 'selenium-webdriver', :require => false
  gem 'capybara-screenshot'
  gem 'database_cleaner', :require => false
  gem 'factory_girl_rails', :require => false
  gem 'launchy', :require => false
  gem 'spork', '0.9.0.rc9', :require => false
end

group :mysql do
  # adapter: mysql2
  gem 'mysql2', :require => false
end

group :postgres do
  # adapter: postgresql
  gem 'pg', '~> 0.15', :require => false
end

group :sqlite do
  # adapter: sqlite3
  gem 'sqlite3', :require => false
end
