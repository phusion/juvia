require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Admin::DashboardController do
  render_views
  
  describe "GET index" do
    def visit_normally
      get :index
    end

    include_examples "doesn't require authentication"
  end

  describe "GET new_admin" do
    def visit_normally
      get :new_admin
    end

    include_examples "doesn't require authentication"

    it "errors out if the system already has administrators" do
      admin
      visit_normally
      response.should render_template('shared/forbidden')
    end
  end
  
  describe "PUT create_admin" do
    def visit_normally
      put :create_admin, :user => {
        :email => 'a@a.com',
        :password => '123456',
        :password_confirmation => '123456'
      }
    end

    include_examples "doesn't require authentication"

    it "creates a new admin user" do
      visit_normally
      user = User.find_by_email('a@a.com')
      user.should_not be_nil
      user.should be_admin
    end
    
    it "errors out if the system already has administrators" do
      admin
      visit_normally
      response.should render_template('shared/forbidden')
    end
  end
  
  describe "GET new_site" do
    def visit_normally
      get :new_site
    end
    
    include_examples "requires authentication"
  end
  
  describe "PUT create_site" do
    def visit_normally
      put :create_site, :site => {
        :name => 'foobar'
      }
    end
    
    include_examples "requires authentication"

    it "creates a new site" do
      sign_in(admin)
      visit_normally
      site = Site.find_by_name('foobar')
      site.should_not be_nil
    end

    it "always assigns the created site to the currently logged in user" do
      sign_in(admin)
      put :create_site, :site => {
        :name => 'foobar',
        :user_id => kotori.id.to_s
      }
      site = Site.find_by_name('foobar')
      site.user_id.should == admin.id
    end
  end
end
