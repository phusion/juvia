class Admin::TopicsController < InheritedResources::Base
  layout 'admin'

  load_and_authorize_resource
  before_filter :set_navigation_ids

  def show
    show! do
      @comments = @topic.comments.page(params[:page])
    end
  end

  def destroy
    destroy! { admin_site_path(@topic.site) }
  end

  def index
    raise "Not allowed"
  end

  def new
    raise "Not allowed"
  end

  def create
    raise "Not allowed"
  end

  def edit
    raise "Not allowed"
  end

  def update
    raise "Not allowed"
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :sites]
  end
end
