require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Admin::DashboardController do
  render_views
  
  describe "new_admin" do
    def visit_normally
      get :new_admin
    end
    
    it "errors out if the system already has administrators" do
      admin
      visit_normally
      pending
    end
  end
  
  describe "create_admin" do
    def visit_normally
      put :create_admin, :user => {
        :email => 'a@a.com',
        :password => '123456',
        :password_confirmation => '123456'
      }
    end
    
    it "errors out if the system already has administrators" do
      admin
      visit_normally
      pending
    end
  end
  
  describe "new_site" do
    def visit_normally
      get :new_site
    end
    
    include_examples "requires authentication"
  end
end
