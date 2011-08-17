require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Admin::SitesController do
  render_views
  
  def valid_attributes
    {  }
  end

  describe "GET index" do
    def visit_normally
      get :index
    end
    
    include_examples "requires authentication"
    include_examples "requires administrator rights"
  end
  
if false
  describe "GET show" do
    include_examples "requires authentication"
    include_examples "requires administrator rights"
    
    it "assigns the requested admin_site as @admin_site" do
      site = Admin::Site.create! valid_attributes
      get :show, :id => site.id.to_s
      assigns(:admin_site).should eq(site)
    end
  end

  describe "GET new" do
    it "assigns a new admin_site as @admin_site" do
      get :new
      assigns(:admin_site).should be_a_new(Admin::Site)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_site as @admin_site" do
      site = Admin::Site.create! valid_attributes
      get :edit, :id => site.id.to_s
      assigns(:admin_site).should eq(site)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::Site" do
        expect {
          post :create, :admin_site => valid_attributes
        }.to change(Admin::Site, :count).by(1)
      end

      it "assigns a newly created admin_site as @admin_site" do
        post :create, :admin_site => valid_attributes
        assigns(:admin_site).should be_a(Admin::Site)
        assigns(:admin_site).should be_persisted
      end

      it "redirects to the created admin_site" do
        post :create, :admin_site => valid_attributes
        response.should redirect_to(Admin::Site.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_site as @admin_site" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Site.any_instance.stub(:save).and_return(false)
        post :create, :admin_site => {}
        assigns(:admin_site).should be_a_new(Admin::Site)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Site.any_instance.stub(:save).and_return(false)
        post :create, :admin_site => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin_site" do
        site = Admin::Site.create! valid_attributes
        # Assuming there are no other admin_sites in the database, this
        # specifies that the Admin::Site created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin::Site.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => site.id, :admin_site => {'these' => 'params'}
      end

      it "assigns the requested admin_site as @admin_site" do
        site = Admin::Site.create! valid_attributes
        put :update, :id => site.id, :admin_site => valid_attributes
        assigns(:admin_site).should eq(site)
      end

      it "redirects to the admin_site" do
        site = Admin::Site.create! valid_attributes
        put :update, :id => site.id, :admin_site => valid_attributes
        response.should redirect_to(site)
      end
    end

    describe "with invalid params" do
      it "assigns the admin_site as @admin_site" do
        site = Admin::Site.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Site.any_instance.stub(:save).and_return(false)
        put :update, :id => site.id.to_s, :admin_site => {}
        assigns(:admin_site).should eq(site)
      end

      it "re-renders the 'edit' template" do
        site = Admin::Site.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Site.any_instance.stub(:save).and_return(false)
        put :update, :id => site.id.to_s, :admin_site => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_site" do
      site = Admin::Site.create! valid_attributes
      expect {
        delete :destroy, :id => site.id.to_s
      }.to change(Admin::Site, :count).by(-1)
    end

    it "redirects to the admin_sites list" do
      site = Admin::Site.create! valid_attributes
      delete :destroy, :id => site.id.to_s
      response.should redirect_to(admin_sites_url)
    end
  end
end
end
