require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/edit.html.erb" do
  before(:each) do
    @site = assign(:site, stub_model(Site))
  end

  it "renders the edit site form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_sites_path(@site), :method => "post" do
    end
  end
end
