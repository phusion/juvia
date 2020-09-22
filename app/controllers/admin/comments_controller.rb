class Admin::CommentsController < ApplicationController
  layout 'admin'

  skip_authorization_check only: %i[preview new_import import]
  before_action :set_navigation_ids
  before_action :save_return_to_url, only: %i[new edit approve destroy]
  before_action :require_admin!, only: %i[new_import import]

  def index
    authorize! :read, Comment
    @all_comments = Comment
                    .accessible_by(current_ability)
                    .order('created_at DESC')
                    .includes(:topic)
    @comments = @all_comments.page(params[:page])
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
    if @comment.update_attributes(params[:comment], as: current_user.role)
      redirect_back(admin_comments_path)
    else
      render action: 'edit'
    end
  end

  def preview
    render text: ApplicationHelper.render_markdown(params[:content])
  end

  def approve
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
    @comment.transaction do
      @comment.moderation_status = :ok
      @comment.report_ham if @comment.site.moderation_method == :akismet
      @comment.save!
    end
    redirect_back(admin_comments_path)
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.transaction do
      @comment.report_spam if params[:spam] && @comment.site.moderation_method == :akismet
      @comment.destroy
    end
    redirect_back(admin_comments_path)
  end

  def new_import
    @sites = Site.all
    @migrators = Juvia::Migrators::PLATFORMS.map { |p| p.titleize }
  end

  def import
    options = { table_prefix: params[:table_prefix],
                wp_multisite_id: params[:wp_multisite_id] }
    if Juvia::Migrators.process(
      params[:site_id],
      params[:import_type],
      params[:database_name],
      params[:database_user],
      params[:database_password],
      params[:database_host],
      options
    )
      flash[:notice] = 'Imported!'
      redirect_to(admin_comments_path)
    end
  end

  private

  def set_navigation_ids
    @navigation_ids = %i[dashboard comments]
  end
end
