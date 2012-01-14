# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Admin::Dashboard" do
  describe "root path" do
    it "offers to setup an administrator account if there is none" do
      visit root_path
      page.should have_content("Let's setup an administrator account first!")
    end
    
    it "offers to setup a site if the logged in user doesn't have any" do
      login(admin)
      visit root_path
      page.should have_content("Let's get started!")
      page.should have_content("So you want to embed comments on a bunch of web pages.")
    end
    
    it "redirects to the sites page if the user is logged in, there are administrators and the current user has sites" do
      FactoryGirl.create(:site1, :user => admin)
      login(admin)
      visit root_path
      current_url.should == admin_sites_url
    end
  end
  
  describe "setting up an initial administrator account" do
    it "creates the account, logs in the user and asks the user to setup a site" do
      visit root_path
      fill_in 'Email', :with => 'a@a.com'
      fill_in 'Password', :with => '123456'
      fill_in 'Confirm password', :with => '123456'
      click_button 'Create account & login'
      user = User.first
      user.email.should == 'a@a.com'
      user.should be_admin
      page.should have_css("#debug .current_user", :text => user.id.to_s)
      page.should have_content("So you want to embed comments on a bunch of web pages")
    end
    
    it "refuses to create the account opon errors" do
      visit root_path
      click_button 'Create account & login'
      page.should have_css("#error_explanation")
      User.count.should == 0
    end
  end
  
  describe "setting up a site" do
    before :each do
      login(admin)
      visit '/admin/dashboard/new_site'
    end
    
    it "works" do
      page.should have_content("So you want to embed comments on a bunch of web pages")
      fill_in 'site[name]', :with => 'Foo'
      choose 'Manually approve all comments.'
      click_button 'Next step »'
      page.should have_content("Your site \"Foo\" has been registered!")
      Site.find_by_name('Foo').should_not be_nil
    end
    
    it "refuses to create the site upon errors" do
      click_button 'Next step »'
      page.should have_content("prohibited this site from being created")
      page.should have_content("So you want to embed comments on a bunch of web pages")
    end
  end
end
