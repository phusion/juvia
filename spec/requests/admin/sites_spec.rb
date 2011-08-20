require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Admin::Sites" do
  describe "/admin/sites" do
    before :each do
      login(kotori)
      @site1 = FactoryGirl.create(:site1, :user => kotori)
      @site2 = FactoryGirl.create(:site2, :user => kotori)
      @site3 = FactoryGirl.create(:site3, :user => morishima)
      visit('/admin/sites')
    end
    
    it "shows all sites that the current user can access" do
      page.should have_css(".sites #site_#{@site1.id}")
      page.should have_css(".sites #site_#{@site2.id}")
    end
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
