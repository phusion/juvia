require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/index.html.erb" do
  before(:each) do
    assign(:admin_sites, [
      stub_model(Admin::Site),
      stub_model(Admin::Site)
    ])
  end

  it "renders a list of admin/sites" do
    render
  end
end
