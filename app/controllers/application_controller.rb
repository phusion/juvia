class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!
  check_authorization :if => :inside_admin_area?

  rescue_from CanCan::AccessDenied do |exception|
    render :template => 'shared/forbidden'
  end

private
  ### before filters
  
  def require_admin!
    if !current_user.admin?
      render :template => 'shared/admin_required'
    end
  end
  
  def save_return_to_url
    if (path = params[:return_to]) && path =~ /\A\//
      session[:return_to] = path
    end
  end
  
  
  ### helpers
  
  def redirect_back(default_url = nil)
    redirect_to(session.delete(:return_to) || :back)
  rescue RedirectBackError
    redirect_to(default_url || root_path)
  end

  def inside_admin_area?
    controller_path =~ /\Aadmin/
  end
end
