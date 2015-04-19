require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe "admin/sites/new.html.erb", type: :view do

  it "renders new site form" do
    assign(:site, stub_model(Site).as_new_record)

    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_sites_path, :method => "post" do
    end
  end
end
