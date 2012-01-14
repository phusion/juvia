class Admin::TopicsController < InheritedResources::Base
  layout 'admin'

  load_and_authorize_resource
  before_filter :set_navigation_ids

  def index
    raise "Not allowed"
  end

  def show
    show! do
      @comments = @topic.comments.paginate(:page => params[:page])
    end
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :sites]
  end
end
