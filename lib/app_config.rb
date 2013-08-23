# If configuration is set in environment, don't bother loading from application.yml
unless ENV['JUVIA_BASE_URL']
  require 'app_config_real'
end