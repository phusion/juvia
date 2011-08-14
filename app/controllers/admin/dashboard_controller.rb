class Admin::DashboardController < ApplicationController
  def index
    redirect_to admin_comments_path
  end
end
