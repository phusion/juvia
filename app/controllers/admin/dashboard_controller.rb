class Admin::DashboardController < ApplicationController
  layout 'admin'
  
  skip_before_filter :authenticate_user!, :only => [:index, :new_admin, :create_admin]
  before_filter :require_admin!, :except => [:index, :new_admin, :create_admin]
  before_filter :set_navigation_ids
  
  def index
    if User.where(:admin => true).count == 0
      redirect_to :action => 'setup_admin'
    elsif Site.count == 0
      redirect_to :action => 'welcome'
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
  end
  
  def new_site
    @site = Site.new
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard]
  end
end
