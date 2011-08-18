class Admin::DashboardController < ApplicationController
  layout 'admin'
  
  skip_before_filter :authenticate_user!, :only => [:index, :new_admin, :create_admin]
  before_filter :require_admin!, :except => [:index, :new_admin, :create_admin]
  before_filter :set_navigation_ids
  
  def index
    if User.where(:admin => true).count == 0
      redirect_to :action => 'new_admin'
    elsif current_user && current_user.accessible_sites.count == 0
      redirect_to :action => 'new_site'
    else
      redirect_to admin_comments_path
    end
  end
  
  def new_admin
    #raise if User.where(:admin => true).count > 0
    @user = User.new
  end
  
  def create_admin
    #raise if User.where(:admin => true).count > 0
    @user = User.new(params[:user])
    @user.admin = true
    if @user.save
      sign_in(@user)
      redirect_to dashboard_path
    else
      render :action => 'new_admin'
    end
  end
  
  def new_site
    @site = Site.new
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard]
  end
end
