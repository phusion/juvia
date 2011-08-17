require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/show.html.erb" do
  before(:each) do
    @admin_site = assign(:admin_site, stub_model(Admin::Site))
  end

  it "renders attributes in <p>" do
    render
  end
end
