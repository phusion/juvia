# -*- Mode: Ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

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
            if false && config[subkey].blank?
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
  end
  
  module RailsExtensions
    attr_accessor :config
  end
end
