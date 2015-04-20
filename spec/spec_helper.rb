require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'capybara-screenshot/rspec'
  require 'capybara-webkit'
  require 'database_cleaner'
  require 'launchy'
  require 'rspec/rails'


  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Capybara.javascript_driver               = :webkit
  Capybara::Screenshot.autosave_on_failure = false

  DatabaseCleaner.logger = Rails.logger
  DatabaseCleaner.strategy = :truncation

  RSpec.configure do |config|
    config.include SpecSupport
    config.include Devise::TestHelpers, :type => :controller
    config.include Devise::TestHelpers, :type => :view
    config.include Capybara::DSL
    config.include Rails.application.routes.url_helpers

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

    # rspec-rails 3 will no longer automatically infer an example group's spec type
    # from the file location. You can explicitly opt-in to the feature using this
    # config option.
    # To explicitly tag specs without using automatic inference, set the `:type`
    # metadata manually:
    #
    #     describe ThingsController, :type => :controller do
    #       # Equivalent to being in spec/controllers
    #     end
    config.infer_spec_type_from_file_location!
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.
  require 'factory_girl_rails'
  RSpec.configure do |config|
    config.include FactoryHelpers
  end
end
