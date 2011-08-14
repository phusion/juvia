class Admin::CommentsController < ApplicationController
  layout 'admin'
  
  before_filter :set_navigation_ids
  before_filter :require_admin!
  
  def index
    @comments = Comment.order('created_at DESC').page(params[:page])
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :comments]
  end
end
