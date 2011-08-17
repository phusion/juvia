# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'spork'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :webkit
DatabaseCleaner.logger = Rails.logger

Spork.each_run do
  ActiveSupport::Dependencies.clear
end

RSpec.configure do |config|
  config.include FactoryHelpers
  config.include SpecSupport
  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :request
  
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # We already use database_cleaner.
  config.use_transactional_fixtures = false
  
  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    if File.exist?('public/_test.html')
      File.unlink('public/_test.html') rescue nil
    end
  end
end
