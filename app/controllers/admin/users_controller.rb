module Admin

class UsersController < ApplicationController
  layout 'admin'
  
  skip_authorization_check :only => :index
  before_filter :set_navigation_ids
  
  def index
    if !can?(:list, User)
      redirect_to dashboard_path
      return
    end

    @users = User.order('email').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user

    respond_to do |format|
      format.json { render :json => @user }
    end
  end
  
  def sites
    @user = User.find(params[:user_id])
    authorize! :read, @user
    @sites = @user.sites.page(params[:page])
  end
  
  def comments
    @user = User.find(params[:user_id])
    authorize! :read, @user
    @comments = @user.comments.page(params[:page])
  end

  def new
    authorize! :create, User
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize! :update, @user
  end

  def create
    authorize! :create, User
    @user = User.new(params[:user], :as => current_user.role)

    respond_to do |format|
      if @user.save
        format.html { redirect_to(admin_users_path, :notice => 'User was successfully created.') }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    respond_to do |format|
      if @user.update_attributes(params[:user], :as => current_user.role)
        format.html { redirect_to(admin_users_path, :notice => 'User was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_path) }
      format.json { head :ok }
    end
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :users]
  end
end

end # module Admin
