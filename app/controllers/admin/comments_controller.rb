class Admin::CommentsController < ApplicationController
  layout 'admin'

  skip_authorization_check :only => :preview
  before_filter :set_navigation_ids
  before_filter :save_return_to_url, :only => [:new, :edit]
  
  def index
    authorize! :read, Comment
    @comments = Comment.order('created_at DESC').page(params[:page])
  end
  
  def edit
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
  end
  
  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
    if @comment.update_attributes(params[:comment], :as => current_user.role)
      redirect_back
    else
      render :action => 'edit'
    end
  end
  
  def preview
    render :text => ApplicationHelper.render_markdown(params[:content])
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :comments]
  end
end
