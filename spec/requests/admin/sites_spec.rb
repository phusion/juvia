require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Admin::Sites" do
  describe "/admin/sites" do
    it "shows all sites that the current user can access"
    it "shows the sites alphabetically"
  end
  
  describe "/admin/sites/:id" do
    it "shows the most recent comments"
  end
  
  describe "/admin/sites/:id/topics" do
    it "shows the most recent topics"
  end
  
  describe "installation page" do
    it "shows installation instructions"
  end
  
  describe "settings page" do
    it "shows the site settings"
    it "allows updating the site settings"
  end
end
