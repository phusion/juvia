require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/new.html.erb" do
  before(:each) do
    assign(:site, stub_model(Site).as_new_record)
  end

  it "renders new site form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_sites_path, :method => "post" do
    end
  end
end
