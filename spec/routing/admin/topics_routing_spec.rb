require "spec_helper"

describe Admin::TopicsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin_topics").should route_to("admin_topics#index")
    end

    it "routes to #new" do
      get("/admin_topics/new").should route_to("admin_topics#new")
    end

    it "routes to #show" do
      get("/admin_topics/1").should route_to("admin_topics#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin_topics/1/edit").should route_to("admin_topics#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin_topics").should route_to("admin_topics#create")
    end

    it "routes to #update" do
      put("/admin_topics/1").should route_to("admin_topics#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin_topics/1").should route_to("admin_topics#destroy", :id => "1")
    end

  end
end
