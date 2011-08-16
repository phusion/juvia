# -*- Mode: Ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'securerandom'
require 'uri'

# If you have a Gemfile, require the default gems, the ones in the
# current environment and also include :assets gems if in development
# or test environments.
Bundler.require *Rails.groups(:assets) if defined?(Bundler)

module Juvia
  class Application < Rails::Application
    require File.expand_path('../../lib/app_config', __FILE__)

    config.required_app_config = [:base_url]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable the asset pipeline
    config.assets.enabled = true
    
    initializer "action_mailer.default_url_options", :after => "app_config" do
      uri = URI.parse(config.base_url)
      config.action_mailer.default_url_options = { :host => uri.host }
      if uri.scheme != "http"
        config.action_mailer.default_url_options[:protocol] = uri.scheme
      end
      if !(uri.scheme == "http" && uri.port == 80) && !(uri.scheme == "https" && uri.port == 443)
        config.action_mailer.default_url_options[:port] = uri.port
      end
    end
  end
end
