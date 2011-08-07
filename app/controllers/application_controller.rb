class ApplicationController < ActionController::Base
  protect_from_forgery
  
  around_filter :set_active_base_url

private
  def set_active_base_url
    Thread.current[:base_url] = @base_url = request.protocol + request.host_with_port
    yield
  ensure
    Thread.current[:base_url] = nil
  end
end
