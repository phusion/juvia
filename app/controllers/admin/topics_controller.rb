class Admin::TopicsController < ApplicationController
  # GET /admin/topics
  # GET /admin/topics.json
  def index
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @topics }
    end
  end

  # GET /admin/topics/1
  # GET /admin/topics/1.json
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @topic }
    end
  end

  # GET /admin/topics/new
  # GET /admin/topics/new.json
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @topic }
    end
  end

  # GET /admin/topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /admin/topics
  # POST /admin/topics.json
  def create
    @topic = Topic.new(params[:topic])

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, :notice => 'Topic was successfully created.' }
        format.json { render :json => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.json { render :json => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/topics/1
  # PUT /admin/topics/1.json
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, :notice => 'Topic was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/topics/1
  # DELETE /admin/topics/1.json
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to admin_topics_url }
      format.json { head :ok }
    end
  end
end
