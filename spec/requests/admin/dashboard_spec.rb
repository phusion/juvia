require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Admin::Dashboard" do
  describe "root path" do
    it "offers to setup an administrator account if there is none"
    it "offers to setup a site if the logged in user doesn't have any"
    it "redirects to the comments page if the user is logged in and there are administrators"
  end
  
  describe "setting up an initial administrator account" do
    it "works"
  end
  
  describe "setting up a site" do
    it "works" do
      visit '/admin/dashboard/new_site'
      page.should have_content("So you want to embed comments on a bunch of web pages")
      fill_in 'site[name]', :with => 'Foo'
      fill_in 'site[moderation_type]'
      click_button 'Next step &raquo;'
      page.should have_content("Your site has been created. Here's how you embed comments in your web pages.")
      Site.find_by_name('Foo').should_not be_nil
    end
    
    it "refuses to create the site upon errors" do
      click_button 'Next step &raquo;'
      page.should have_content("prohibited this site from being created")
      page.should have_content("So you want to embed comments on a bunch of web pages")
    end
  end
end
