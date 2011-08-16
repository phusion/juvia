require "spec_helper"

describe Admin::SitesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/sites").should route_to("admin/sites#index")
    end

    it "routes to #new" do
      get("/admin/sites/new").should route_to("admin/sites#new")
    end

    it "routes to #show" do
      get("/admin/sites/1").should route_to("admin/sites#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/sites/1/edit").should route_to("admin/sites#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/sites").should route_to("admin/sites#create")
    end

    it "routes to #update" do
      put("/admin/sites/1").should route_to("admin/sites#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/sites/1").should route_to("admin/sites#destroy", :id => "1")
    end

  end
end
