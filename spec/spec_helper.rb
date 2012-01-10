require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'capybara'
  require 'capybara-webkit'
  require 'database_cleaner'
  require 'launchy'
  require 'rspec/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Capybara.javascript_driver = :webkit
  DatabaseCleaner.logger = Rails.logger
  DatabaseCleaner.strategy = :truncation

  RSpec.configure do |config|
    config.include SpecSupport
    config.include Devise::TestHelpers, :type => :controller
    
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec
    
    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
      if File.exist?('public/_test.html')
        File.unlink('public/_test.html') rescue nil
      end
    end
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.
  require 'factory_girl_rails'
  RSpec.configure do |config|
    config.include FactoryHelpers
  end
end
