require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Admin::SitesController do
  def valid_attributes
    { :name => 'Foo',
      :url => 'http://foo.local/' }
  end

  def create_site
    @site ||= FactoryGirl.create(:site1, :user => kotori)
  end

  describe "GET index" do
    def visit_normally
      get :index
    end
    
    include_examples "requires authentication"
  end
  
  describe "GET show" do
    def visit_normally
      get :show, :id => create_site.id.to_s
    end

    include_examples "requires authentication"
  end

  describe "GET new" do
    def visit_normally
      get :new
    end

    include_examples "requires authentication"
  end

  describe "GET edit" do
    def visit_normally
      get :edit, :id => create_site.id.to_s
    end

    include_examples "requires authentication"
  end

  describe "POST create" do
    def visit_normally
      post :create, :site => valid_attributes
    end

    include_examples "requires authentication"
  end

  describe "PUT update" do
    def visit_normally
      put :update, :id => create_site.id.to_s, :site => valid_attributes
    end

    include_examples "requires authentication"
  end

  describe "DELETE destroy" do
    def visit_normally
      delete :destroy, :id => create_site.id.to_s
    end

    include_examples "requires authentication"
  end

  describe "GET created" do
    def visit_normally
      get :created, :id => create_site.id.to_s
    end

    include_examples "requires authentication"
  end

  describe "GET test" do
    def visit_normally
      get :test, :id => create_site.id.to_s
    end

    include_examples "requires authentication"
  end
end

describe Admin::SitesController do
  render_views

  before :each do
    sign_in(admin)
  end

  def valid_attributes
    { :name => 'Foo',
      :url => 'http://foo.local/' }
  end

  def create_site
    @site ||= FactoryGirl.create(:site1, :user => admin)
  end

  describe "GET show" do
    before :each do
      create_site
    end

    def visit_normally
      get :show, :id => @site.id.to_s
    end

    it "assigns the requested site as @site" do
      visit_normally
      assigns(:site).should eq(@site)
    end
  end

  describe "GET new" do
    it "assigns a new site as @site" do
      get :new
      assigns(:site).should be_a_new(Site)
    end
  end

  describe "GET edit" do
    it "assigns the requested site as @site" do
      site = create_site
      get :edit, :id => site.id.to_s
      assigns(:site).should eq(site)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Site" do
        expect {
          post :create, :site => valid_attributes
        }.to change(Site, :count).by(1)
      end

      it "assigns a newly created site as @site" do
        post :create, :site => valid_attributes
        assigns(:site).should be_a(Site)
        assigns(:site).should be_persisted
      end

      it "redirects to the created site" do
        post :create, :site => valid_attributes
        response.should redirect_to([:admin, Site.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved site as @site" do
        # Trigger the behavior that occurs when invalid params are submitted
        Site.any_instance.stub(:save).and_return(false)
        post :create, :site => {}
        assigns(:site).should be_a_new(Site)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Site.any_instance.stub(:save).and_return(false)
        post :create, :site => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested site" do
        site = create_site
        # Assuming there are no other sites in the database, this
        # specifies that the Site created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Site.any_instance.should_receive(:update_attributes).with({ 'name' => 'bar' }, :as => :admin)
        put :update, :id => site.id, :site => { 'name' => 'bar' }
      end

      it "assigns the requested site as @site" do
        site = create_site
        put :update, :id => site.id, :site => valid_attributes
        assigns(:site).should eq(site)
      end

      it "redirects to the site" do
        site = create_site
        put :update, :id => site.id, :site => valid_attributes
        response.should redirect_to([:admin, site])
      end
    end

    describe "with invalid params" do
      it "assigns the site as @site" do
        site = create_site
        # Trigger the behavior that occurs when invalid params are submitted
        Site.any_instance.stub(:save).and_return(false)
        put :update, :id => site.id.to_s, :site => {}
        assigns(:site).should eq(site)
      end

      it "re-renders the 'edit' template" do
        site = create_site
        # Trigger the behavior that occurs when invalid params are submitted
        Site.any_instance.stub(:save).and_return(false)
        put :update, :id => site.id.to_s, :site => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested site" do
      site = create_site
      expect {
        delete :destroy, :id => site.id.to_s
      }.to change(Site, :count).by(-1)
    end

    it "redirects to the sites list" do
      site = create_site
      delete :destroy, :id => site.id.to_s
      response.should redirect_to(admin_sites_url)
    end
  end

  describe "GET created" do
    it "displays embedding instructions" do
      site = create_site
      get :created, :id => site.id.to_s
      response.body.should include("Paste the following snippet into your web pages to embed comments")
      response.body.should include(site.key)
    end
  end

  describe "GET test" do
    it "displays a test page" do
      site = create_site
      get :test, :id => site.id.to_s
      response.body.should include("Test page for site")
      response.body.should include(site.key)
    end
  end
end
