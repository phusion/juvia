class ApplicationController < ActionController::Base
  protect_from_forgery
  
  around_filter :set_active_base_url
  before_filter :authenticate_user!

private
  ### before filters
  
  def set_active_base_url
    Thread.current[:base_url] = @base_url = request.protocol + request.host_with_port
    yield
  ensure
    Thread.current[:base_url] = nil
  end
  
  def require_admin!
    if !current_user.admin?
      render :template => 'shared/admin_required'
    end
  end
  
  def save_return_to_url
    session[:return_to] ||= begin
      path = params[:return_to]
      if path && path =~ /\A\//
        path
      else
        nil
      end
    end
  end
  
  
  ### helpers
  
  def redirect_back(default_url = nil)
    redirect_to(session.delete(:return_to) || :back)
  rescue RedirectBackError
    redirect_to(default_url || root_path)
  end
end
