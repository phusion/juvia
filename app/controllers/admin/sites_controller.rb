class Admin::SitesController < ApplicationController
  layout 'admin'
  
  before_filter :set_navigation_ids
  
  # GET /admin/sites
  # GET /admin/sites.json
  def index
    @sites = Site.order('name').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @sites }
    end
  end

  # GET /admin/sites/1
  # GET /admin/sites/1.json
  def show
    @site = Site.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @site }
    end
  end

  # GET /admin/sites/new
  # GET /admin/sites/new.json
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @site }
    end
  end

  # GET /admin/sites/1/edit
  def edit
    @site = Site.find(params[:id])
  end

  # POST /admin/sites
  # POST /admin/sites.json
  def create
    @site = Site.new(params[:site])
    @site.user = current_user

    respond_to do |format|
      if @site.save
        format.html { redirect_to created_admin_site_path(@site) }
        format.json { render :json => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.json { render :json => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/sites/1
  # PUT /admin/sites/1.json
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to [:admin, @site], :notice => 'Site was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/sites/1
  # DELETE /admin/sites/1.json
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to admin_sites_path }
      format.json { head :ok }
    end
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :sites]
  end
end
