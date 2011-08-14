class Admin::SitesController < ApplicationController
  layout 'admin'
  
  before_filter :set_navigation_ids
  before_filter :require_admin!
  
private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :sites]
  end
end
