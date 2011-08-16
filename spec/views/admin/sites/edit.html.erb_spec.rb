require 'spec_helper'

describe "admin/sites/edit.html.erb" do
  before(:each) do
    @admin_site = assign(:admin_site, stub_model(Admin::Site))
  end

  it "renders the edit admin_site form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_sites_path(@admin_site), :method => "post" do
    end
  end
end
