class Admin::CommentsController < ApplicationController
  layout 'admin'

  skip_authorization_check :only => :preview
  before_filter :set_navigation_ids
  before_filter :save_return_to_url, :only => [:new, :edit, :approve, :destroy]
  
  def index
    authorize! :read, Comment
    @all_comments = Comment.
      accessible_by(current_ability).
      order('created_at DESC').
      includes(:topic)
    @comments = @all_comments.page(params[:page])
  end
  
  def edit
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
  end
  
  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
    if @comment.update_attributes(params[:comment], :as => current_user.role)
      redirect_back(admin_comments_path)
    else
      render :action => 'edit'
    end
  end
  
  def preview
    render :text => ApplicationHelper.render_markdown(params[:content])
  end

  def approve
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
    @comment.transaction do
      @comment.moderation_status = :ok
      if @comment.site.moderation_method == :akismet
        @comment.report_ham
      end
      @comment.save!
    end
    redirect_back(admin_comments_path)
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.transaction do
      if params[:spam] && @comment.site.moderation_method == :akismet
        @comment.report_spam
      end
      @comment.destroy
    end
    redirect_back(admin_comments_path)
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :comments]
  end
end
