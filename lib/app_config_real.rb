# -*- Mode: Ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

# # AppConfig - User configuration for Rails apps
#
# AppConfig allows users to modify application configuration through
# config/application.yml. It does not replace database.yml but it can
# be used to centralize other configuration that would otherwise be
# scattered among many Ruby files (environments/*.rb, initializers/devise.rb,
# etc.). With AppConfig you can consolidate all configuration into a single
# yaml file so that your users don't have to learn Ruby.
#
# AppConfig allows the developer to specify required configuration options.
# AppConfig will check whether these options are set, and raise an
# error during startup if they're not.
#
# `config/application.yml` is sectioned by the RAILS_ENV value, just like
# database.yml. Here's an example of how it may look like:
#
#     development:
#       email_from: info@phusion.nl
#       email_cc: foo@bar.com
#       api_address:
#         host: www.myapi.com
#         username: foo
#         password: bar
#     
#     test:
#       ...
#     
#     production:
#       ...
#
# AppConfig will only load the configuration for the current RAILS_ENV.
#
# ## Installation
#
# Copy this file into `lib` and modify `config/application.rb`:
#
#     module YourName
#       class Application < Rails::Application
#         # Add these!
#         require File.expand_path('../../lib/app_config', __FILE__)
#         config.required_app_config = [...]
#
# `required_app_config` is a list of symbols or hashes mapping symbols to
# arrays. These describe the required configuration options. For example,
# if we require the `email_from` and the `api_address` -> `host` options to
# be set, then we write this:
#
#     config.required_app_config = [:email_from, { :api_address => [:host] }]
#
# ## Accessing configuration
#
# Configuration can be accessed through `Rails.config`, which is a hash with
# indifferent access:
#
#     Rails.config[:email_from]             # => "info@phusion.nl"
#     Rails.config["email_from"]            # => "info@phusion.nl"
#     Rails.config[:api_address][:host]     # => "wwww.myapi.com"
#
# Or it can be accessed through the `config` attribute on your application
# object:
#
#     YourName::Application.config.email_from        # => "info@phusion.nl"
#     YourName::Application.config.api_address.host  # => "www.myapi.com"

module AppConfig
  class Railtie < Rails::Railtie
    initializer "app_config" do |app|
      require 'yaml'
      require 'ostruct'
    
      Rails.extend(AppConfig::RailsExtensions)
    
      config_file = "#{app.root}/config/application.yml"
      config = YAML.load_file(config_file)
    
      if !config[Rails.env]
        abort "#{config_file} must contain configuration for the '#{Rails.env}' environment."
      end
    
      config = recursively_make_indifferent_access(config[Rails.env])
      Rails.config = config
      install_into_app_config(config, app.config)
      if !check_requirements(nil, config, app.config.required_app_config)
        abort "Please edit #{config_file} and set the aforementioned settings."
      end

      install_email_config(app, config)
    end
  
    private
  
    def recursively_make_indifferent_access(hash)
      hash = hash.with_indifferent_access
      hash.each_pair do |key, value|
        if value.is_a?(Hash)
          hash[key] = recursively_make_indifferent_access(value) 
        end
      end
      hash
    end
  
    def install_into_app_config(config, app_config)
      config.each_pair do |key, value|
        if value.is_a?(Hash)
          sub_app_config = OpenStruct.new
          app_config.send("#{key}=", sub_app_config)
          install_into_app_config(value, sub_app_config)
        else
          app_config.send("#{key}=", value)
        end
      end
    end
  
    def check_requirements(namespace, config, requirements)
      result = true
      requirements.each do |key|
        if key.is_a?(Hash)
          key.each_pair do |subkey, subrequirements|
            if config[subkey].blank?
              STDERR.puts "The application setting '#{namespace}#{subkey}' must be set."
              result = false
            else
              subresult = check_requirements("#{namespace}#{subkey}.", config[subkey] || {}, subrequirements)
              result = result && subresult
            end
          end
        elsif config[key].blank?
          STDERR.puts "The application setting '#{namespace}#{key}' must be set."
          result = false
        end
      end
      result
    end

    def install_email_config(app, config)
      if email_config = config[:email]
        if base_url = email_config[:base_url]
          uri = URI.parse(base_url)
          app.config.action_mailer.default_url_options = { :host => uri.host }
          if uri.scheme != "http"
            app.config.action_mailer.default_url_options[:protocol] = uri.scheme
          end
          if !(uri.scheme == "http" && uri.port == 80) && !(uri.scheme == "https" && uri.port == 443)
            app.config.action_mailer.default_url_options[:port] = uri.port
          end
        end
      
        if delivery_method = config[:delivery_method]
          app.config.action_mailer.delivery_method = delivery_method.to_sym
        end
      end
    end
  end

  module RailsExtensions
    attr_accessor :config
  end
end
