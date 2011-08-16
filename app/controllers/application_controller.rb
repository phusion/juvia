class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!

private
  ### before filters
  
  def require_admin!
    if !current_user.admin?
      render :template => 'shared/admin_required'
    end
  end
  
  
  ### helpers
  
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
  
  def redirect_back(default_url = nil)
    redirect_to(session.delete(:return_to) || :back)
  rescue RedirectBackError
    redirect_to(default_url || root_path)
  end
end
