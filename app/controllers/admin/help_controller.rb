class Admin::HelpController < ApplicationController
  layout 'help'
  
  skip_before_filter :authenticate_user!
  before_filter :set_navigation_ids

  def index
  	redirect_to :action => 'embedding'
  end

private
  def set_navigation_ids
    @navigation_ids = [:help]
  end
end
